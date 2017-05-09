package ru.koldoon.tools {
    /**
     * Используется для формата времени.
     *
     * @param value
     * @return
     */
    public function leadingZero(value:Number):String {
        if (value < 10) {
            return "0" + value.toString();
        }
        else {
            return value.toString();
        }
    }
}
