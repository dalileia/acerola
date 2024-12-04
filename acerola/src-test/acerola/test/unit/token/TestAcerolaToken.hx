package acerola.test.unit.token;

import anonstruct.AnonStruct;
import acerola.token.AcerolaToken;
import haxe.io.Bytes;
import utest.Assert;
import utest.Test;

class TestAcerolaToken extends Test {

    function test_if_generated_token_is_correct() {
        // ARRANGE
        var valueKey:String = "This is my secret key";
        var valuePayload:String = "This is the token Payload";
        var valueExpirationDate:Date = Date.fromString('2020-01-01 23:59:59');
        var expectedTokenValue:String = 'AT AQAA5AcAARc7OxsAACJUaGlzIGlzIHRoZSB0b2tlbiBQYXlsb2FkIsiWswAjdj2ueT4V1cinkCmoKDBY9iFCf7DIOE7MPU_h';
        var resultToken:String;

        // ACT
        var token:AcerolaToken<String> = new AcerolaToken<String>();
        token.rounds = 0;
        token.expiresIn = valueExpirationDate;
        token.setPayload(valuePayload);

        resultToken = token.getToken(valueKey);

        // ASSERT
        Assert.equals(expectedTokenValue, resultToken);
    }

    function test_if_loaded_token_is_correct() {
        // ARRANGE
        var valueKey:String = "This is my secret key";
        var valueTokenString:String = 'AT AQAA5AcAARc7OxsAACJUaGlzIGlzIHRoZSB0b2tlbiBQYXlsb2FkIsiWswAjdj2ueT4V1cinkCmoKDBY9iFCf7DIOE7MPU_h';

        // ACT
        var token:AcerolaToken<String> = AcerolaToken.decode(valueTokenString);

        // ASSERT
        Assert.same("This is the token Payload", token.getPayload());

    }

    function test_if_wrong_signture_fail() {
        // ARRANGE
        var valueKey:String = "Wrong Key";
        var valueTokenString:String = 'AT AQAA5AcAARc7OxsAACJUaGlzIGlzIHRoZSB0b2tlbiBQYXlsb2FkIsiWswAjdj2ueT4V1cinkCmoKDBY9iFCf7DIOE7MPU_h';
        var valueCurrDate:Date = Date.fromString('2020-01-02 00:00:00');

        var resultErrorMessage:String;
        var expectedErrorMessage:String = AcerolaTokenErrorCode.ERR_INVALID_SIGNATURE.toString();

        // ACT
        var token:AcerolaToken<String> = AcerolaToken.decode(valueTokenString);

        try {
            token.validate(valueKey, valueCurrDate);
            resultErrorMessage = '';
        } catch (e:AcerolaTokenError) {
            resultErrorMessage = e.toString();
        }

        // ASSERT
        Assert.equals(expectedErrorMessage, resultErrorMessage);
    }

    function test_if_token_is_expired() {
        // ARRANGE
        var valueKey:String = "This is my secret key";
        var valueTokenString:String = 'AT AQAA5AcAARc7OxsAACJUaGlzIGlzIHRoZSB0b2tlbiBQYXlsb2FkIsiWswAjdj2ueT4V1cinkCmoKDBY9iFCf7DIOE7MPU_h';
        var valueCurrDate:Date = Date.fromString('2020-01-02 00:00:00');

        var resultErrorMessage:String;
        var expectedErrorMessage:String = AcerolaTokenErrorCode.ERR_EXPIRED_TOKEN.toString();

        // ACT
        var token:AcerolaToken<String> = AcerolaToken.decode(valueTokenString);
        try {
            token.validate(valueKey, valueCurrDate);
            resultErrorMessage = '';
        } catch (e:AcerolaTokenError) {
            resultErrorMessage = e.toString();
        }

        // ASSERT
        Assert.equals(expectedErrorMessage, resultErrorMessage);
    }

    function test_unable_to_read_invalid_token() {
        // ARRANGE
        var valueTokenString:String = 'AT hjfekdfjks';

        var resultErrorMessage:String;
        var expectedErrorMessage:String = AcerolaTokenErrorCode.ERR_INVALID_TOKEN.toString();

        // ACT
        try {
            AcerolaToken.decode(valueTokenString);
            resultErrorMessage = '';
        } catch (e:AcerolaTokenError) {
            resultErrorMessage = e.toString();
        }

        // ASSERT
        Assert.equals(expectedErrorMessage, resultErrorMessage);
    }

    function test_validate_payload_in_is_equals_payload_out() {
        // ARRANGE
        var valueKey:String = "key";
        var valuePayload:Dynamic = {
            hello : "world"
        };

        var valueExpirationDate:Date = Date.fromString('2020-01-01 23:59:59');
        
        var resultPayload:Dynamic;
        var expectedPayload:Dynamic = {
            hello : "world"
        };

        // ACT
        var token:AcerolaToken<Dynamic> = new AcerolaToken<Dynamic>();
        token.expiresIn = valueExpirationDate;
        token.setPayload(valuePayload);

        var decodeToken:AcerolaToken<Dynamic> = AcerolaToken.decode(token.getToken(valueKey));
        resultPayload = decodeToken.getPayload();

        // ASSERT
        Assert.same(expectedPayload, resultPayload);
    }

    function test_validate_payload_format_shold_fail_validation() {
        // ARRANGE
        var valueKey:String = "key";
        var valuePayload:Dynamic = {
            hello : null
        };

        var valueExpirationDate:Date = Date.fromString('2020-01-01 23:59:59');

        var resultErrorMessage:String;
        var expectedErrorMessage:String = AcerolaTokenErrorCode.ERR_INVALID_PAYLOAD_FORMAT.toString();

        // ACT
        var token:AcerolaToken<Dynamic> = new AcerolaToken<Dynamic>();
        token.expiresIn = valueExpirationDate;
        token.setPayload(valuePayload);

        var decodeToken:AcerolaToken<Dynamic> = AcerolaToken.decode(token.getToken(valueKey));

        try {
            decodeToken.getPayload(PayloadTestValidator);
            resultErrorMessage = '';
        } catch (e:AcerolaTokenError) {
            resultErrorMessage = e.toString();
        }

        // ASSERT
        Assert.equals(expectedErrorMessage, resultErrorMessage);
    }

    function test_validate_payload_format_shold_pass_validation() {
        // ARRANGE
        var valueKey:String = "key";
        var valuePayload:Dynamic = {
            hello : 'world'
        };

        var valueExpirationDate:Date = Date.fromString('2020-01-01 23:59:59');
        var resultPayload:Dynamic;
        var expectedPayload:Dynamic = {
            hello : 'world'
        };

        // ACT
        var token:AcerolaToken<Dynamic> = new AcerolaToken<Dynamic>();
        token.expiresIn = valueExpirationDate;
        token.setPayload(valuePayload);

        var decodeToken:AcerolaToken<Dynamic> = AcerolaToken.decode(token.getToken(valueKey));
        resultPayload = decodeToken.getPayload(PayloadTestValidator);

        // ASSERT
        Assert.same(expectedPayload, resultPayload);
    }

}

private class PayloadTestValidator extends AnonStruct {

    public function new() {
        super();

        this.propertyString('hello')
            .refuseEmpty()
            .refuseNull();
        
    }
}
