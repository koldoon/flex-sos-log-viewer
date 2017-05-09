package ru.koldoon.tools {
    public function and(...params):Boolean {
        if (!params) {
            return false;
        }

        var len:int = params.length;

        for (var i:int = 0; i < len; i++) {
            if (!params[i]) {
                return false;
            }
        }

        return true;
    }
}
