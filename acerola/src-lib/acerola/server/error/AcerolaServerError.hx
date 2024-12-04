package acerola.server.error;

import helper.kits.StringKit;

class AcerolaServerError {
    
    public var status:Int;
    public var errorSource:String;
    public var message:String;
    public var internal:String;

    public function new(status:Int, errorSource:String, message:String, internal:String) {
        this.status = status;
        this.errorSource = errorSource;
        this.message = message;
        this.internal = internal;
    }
    
    public function toString():String {
        if (this.errorSource.length == 0) return this.message;
        else return '${this.errorSource}: ${this.message}';
    }

    public function toData():AcerolaServerErrorData {
        return {
            status : this.status,
            message : this.message,
            error_code : StringKit.isEmpty(this.errorSource) ? 'STATUS_${this.status}' : this.errorSource,
            internal : this.internal
        }
    }

    // Essa resposta significa que o servidor não entendeu a requisição pois está com uma sintaxe inválida.
    static public function INVALID_REQUEST(techMessage:String, ?code:String=''):AcerolaServerError return new AcerolaServerError(400, code, 'Bad Request', techMessage);
    static public function INVALID_REQUEST_DETAILED(message:String, techMessage:String, ?code:String=''):AcerolaServerError return new AcerolaServerError(400, code, message, techMessage);

    // Embora o padrão HTTP especifique "unauthorized", semanticamente, essa resposta significa "unauthenticated".
    // Ou seja, o cliente deve se autenticar para obter a resposta solicitada.
    // https://developer.mozilla.org/pt-BR/docs/Web/HTTP/Status/401
    static public function UNAUTHORIZED_REQUEST(techMessage:String, ?code:String=''):AcerolaServerError return new AcerolaServerError(401, code, 'Unauthorized', techMessage);

    // O cliente não tem direitos de acesso ao conteúdo portanto o servidor está rejeitando dar a resposta.
    // Diferente do código 401, aqui a identidade do cliente é conhecida.
    // Esse status é semelhante ao 401 , mas neste caso, a re-autenticação não fará diferença.
    // O acesso é permanentemente proibido e vinculado à lógica da aplicação (como uma senha incorreta).
    // https://developer.mozilla.org/pt-BR/docs/Web/HTTP/Status/403
    static public function FORBIDDEN(message:String, ?techMessage:String, ?code:String=''):AcerolaServerError return new AcerolaServerError(403, code, message, techMessage);

    // O servidor não pode encontrar o recurso solicitado.
    static public function NOT_FOUND(techMessage:String, ?code:String=''):AcerolaServerError return new AcerolaServerError(404, code, 'Not Found', techMessage);

    // Esta resposta será enviada quando uma requisição conflitar com o estado atual do servidor.
    static public function CONFLICT(message:String, techMessage:String, ?code:String=''):AcerolaServerError return new AcerolaServerError(409, code, message, techMessage);

    // O servidor encontrou uma situação com a qual não sabe lidar.
    static public function SERVER_ERROR(techMessage:String, ?code:String=''):AcerolaServerError return new AcerolaServerError(500, code, 'Server Error', techMessage);

    static public function SERVER_UNAVAILABLE(techMessage:String, ?code:String=''):AcerolaServerError return new AcerolaServerError(503, code, 'Service Unavailable', techMessage);
    static public function SERVER_TIMEOUT(techMessage:String, ?code:String=''):AcerolaServerError return new AcerolaServerError(504, code, 'Server Timeout', techMessage);

}
