package acerola.model;

import acerola.server.error.AcerolaServerError;

typedef AcerolaCallback = {
    var onSuccess:()->Void;
    var onError:(error:AcerolaServerError)->Void;
}