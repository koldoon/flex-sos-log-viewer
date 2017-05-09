package ru.koldoon.model {
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import mx.collections.ArrayCollection;

    public class TextLogItem {
        [Bindable]
        public var fileName:String;

        [Bindable]
        public var textLines:ArrayCollection;

        [Bindable]
        public var errorsCount:int;

        private var updateTimer:int;

        private var file:File;


        public function TextLogItem(file:File) {
            this.file = file;
            fileName = file.name;

            refresh();
        }


        public function refresh():void {
            var fs:FileStream = new FileStream();
            fs.open(file, FileMode.READ);
            textLines = new ArrayCollection(fs.readUTFBytes(fs.bytesAvailable).split("\n"));
        }


        public function toString():String {
            return fileName;
        }
    }
}
