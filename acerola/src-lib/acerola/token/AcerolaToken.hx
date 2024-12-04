package acerola.token;

import anonstruct.AnonStruct;
import haxe.crypto.Sha256;
import haxe.crypto.Base64;
import helper.kits.NumberKit;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;

class AcerolaToken<T> {

    static private var CURRENT_VERSION:Int = 1;
    static private var MIN_ROUNDS:Int = 100;

    // MODEL
    // offset  0           1          3                  10                 13
    //      AT [version:1b][rounds:2b][yyyymmddhhmmss:7b][payload_length:3b][payload:nb][signature:32b]

    private var payload:Bytes;

    public var expiresIn:Date;
    public var rounds:Int;

    private var version:Int;
    private var loadedSignature:Bytes;

    @:isVar public var error(get, null):String;

    public function new() {
        this.error = '';

        this.rounds = MIN_ROUNDS + NumberKit.getRandom(6000, true);
        this.version = CURRENT_VERSION;
        this.expiresInSeconds(60);
    }

    private function get_error():String return this.error;

    inline private function decodeDateFromBytes(b:BytesInput):Date {
        return new Date(
            b.readUInt16(),
            b.readByte(),
            b.readByte(),
            b.readByte(),
            b.readByte(),
            b.readByte()
        );
    }

    inline private function encodeDateInBytes(date:Date, b:BytesOutput):Void {
        b.writeUInt16(date.getFullYear());
        b.writeByte(date.getMonth());
        b.writeByte(date.getDate());
        b.writeByte(date.getHours());
        b.writeByte(date.getMinutes());
        b.writeByte(date.getSeconds());
    }

    public function getPayload(?validator:Class<AnonStruct>):T {
        var result:T = null;

        try {
            result = haxe.Json.parse(this.payload.toString());
        } catch (e:Dynamic) {
            throw new AcerolaTokenError(AcerolaTokenErrorCode.ERR_INVALID_PAYLOAD_FORMAT);
        }

        if (validator != null) {
            var anonStruct:AnonStruct = Type.createInstance(validator, []);
            if (!anonStruct.pass(result)) throw new AcerolaTokenError(AcerolaTokenErrorCode.ERR_INVALID_PAYLOAD_FORMAT);
        }

        return result;
    }

    public function setPayload(payload:T):Void this.payload = Bytes.ofString(haxe.Json.stringify(payload));

    public function expiresInSeconds(seconds:Int):Void this.expiresIn = Date.fromTime(Date.now().getTime() + seconds * 1000);
    public function expiresInHours(hours:Int):Void this.expiresInSeconds(hours * 3600);

    public function getToken(key:String):String {
        var b:BytesOutput = new BytesOutput();

        b.writeByte(this.version);
        b.writeUInt16(this.rounds);
        this.encodeDateInBytes(this.expiresIn, b);

        b.writeUInt24(this.payload.length);
        b.write(this.payload);

        b.write(this.generateSignature(key));

        return 'AT ' + Base64.urlEncode(b.getBytes());
    }

    private function generateSignature(key:String):Bytes {
        var keyBytes:Bytes = Sha256.make(Bytes.ofString(key));
        var k1:Bytes = Sha256.make(keyBytes);
        var k2:Bytes = Sha256.make(k1);

        var dataToSign:BytesOutput = new BytesOutput();
        dataToSign.write(k2);
        dataToSign.writeByte(this.version);
        dataToSign.write(Bytes.ofString(DateTools.format(this.expiresIn, "%Y-%m-%d %H:%M:%S")));
        dataToSign.write(this.payload);

        var k3:Bytes = Sha256.make(dataToSign.getBytes());

        var finalData:BytesOutput = new BytesOutput();
        finalData.write(k1);
        finalData.write(k3);

        var finalSha = Sha256.make(finalData.getBytes());
        
        for (i in 0 ... this.rounds) finalSha = Sha256.make(finalSha);
        return finalSha;
    }

    public function validate(key:String, currentDate:Date):Void {
        if (this.loadedSignature == null) AcerolaTokenError.doThrow(ERR_NOT_LOADED_TOKEN);
        else if (this.loadedSignature.compare(this.generateSignature(key)) != 0) AcerolaTokenError.doThrow(ERR_INVALID_SIGNATURE);
        else if (this.expiresIn.getTime() <= currentDate.getTime()) AcerolaTokenError.doThrow(ERR_EXPIRED_TOKEN);
    }

    static public function decode<S>(token:String):AcerolaToken<S> {
        var result:AcerolaToken<S> = new AcerolaToken<S>();

        var tokenHead:String = 'AT ';

        var decodeVersion01 = function(buf:BytesInput):Void {
            result.version = buf.readByte();
            result.rounds = buf.readUInt16();
            result.expiresIn = result.decodeDateFromBytes(buf);
    
            var payloadLength:Int = buf.readUInt24();
            result.payload = buf.read(payloadLength);
            
            result.loadedSignature = buf.readAll();
        }

        if (!StringTools.startsWith(token, tokenHead)) AcerolaTokenError.doThrow(ERR_NOT_SIGNED);
        else {
            try {
                var tokenDataBase64:String = token.substr(tokenHead.length);
                var b:BytesInput = new BytesInput(Base64.urlDecode(tokenDataBase64));

                var version:Int = b.readByte();
                b.position = 0;

                switch (version) {
                    case 1: decodeVersion01(b);
                    case _: AcerolaTokenError.doThrow(ERR_WRONG_VERSION);
                }
            } catch (e) {
                AcerolaTokenError.doThrow(ERR_INVALID_TOKEN);
            }
        }

        return result;
    }
    
}

enum abstract AcerolaTokenErrorCode(Int) to Int {
    var ERR_NOT_SIGNED = 1;
    var ERR_WRONG_VERSION = 2;
    var ERR_INVALID_TOKEN = 3;
    var ERR_INVALID_SIGNATURE = 4;
    var ERR_EXPIRED_TOKEN = 5;
    var ERR_NOT_LOADED_TOKEN = 6;
    var ERR_INVALID_PAYLOAD_FORMAT = 7;

    public function toString():String {
        return switch (this) {
            case ERR_NOT_SIGNED: 'Token is not Signed Payload type';
            case ERR_WRONG_VERSION: 'Wrong Token Version';
            case ERR_INVALID_TOKEN: 'Invalid Token Format';
            case ERR_INVALID_SIGNATURE: 'Invalid Signature';
            case ERR_EXPIRED_TOKEN: 'Token is Expired';
            case ERR_NOT_LOADED_TOKEN: 'Token is not Loaded';
            case ERR_INVALID_PAYLOAD_FORMAT: 'Invalid Payload Format';
            case _: 'Unknown Error';
        }
    }
}

class AcerolaTokenError {
    
    public var code:AcerolaTokenErrorCode;

    public function new(code:AcerolaTokenErrorCode) {
        this.code = code;
    }

    public function toString():String return this.code.toString();

    static public function doThrow(code:AcerolaTokenErrorCode) throw new AcerolaTokenError(code);
}