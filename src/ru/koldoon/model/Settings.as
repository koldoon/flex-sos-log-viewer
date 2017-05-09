package ru.koldoon.model {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.geom.Rectangle;
    import flash.net.SharedObject;

    [Event(name="dataChange", type="flash.events.Event")]

    public class Settings extends EventDispatcher {
        public static const BACKGROUND_TYPE_BLUE:String = "blue";
        public static const BACKGROUND_TYPE_BLACK:String = "black";
        public static const BACKGROUND_TYPE_COLOR:String = "color";

        private var sharedObj:SharedObject;
        private var settingsData:Object = {};

        // -----------------------------------------------------------------------------------
        // Singleton
        // -----------------------------------------------------------------------------------

        private static var _instance:Settings;


        [Bindable("__NoChangeEvent__")]
        public static function getInstance():Settings {
            if (!_instance) {
                _instance = new Settings();
            }

            return _instance;
        }


        // -----------------------------------------------------------------------------------
        // Properties
        // -----------------------------------------------------------------------------------

        [Bindable(event="dataChange")]
        public function get wordWrapEnabled():Boolean {
            return settingsData.wordWrapEnabled;
        }


        public function set wordWrapEnabled(value:Boolean):void {
            settingsData.wordWrapEnabled = value;
            dispatchEvent(new Event("dataChange"));
            writeSettings();
        }


        private var _autoScrollEnabled:Boolean = true;

        [Bindable]
        public function get autoScrollEnabled():Boolean {
            return _autoScrollEnabled;
        }


        public function set autoScrollEnabled(value:Boolean):void {
            _autoScrollEnabled = value;
        }


        [Bindable(event="dataChange")]
        public function get transparencyEnabled():Boolean {
            return settingsData.transparencyEnabled;
        }


        public function set transparencyEnabled(value:Boolean):void {
            settingsData.transparencyEnabled = value;
            dispatchEvent(new Event("dataChange"));
            writeSettings();
        }


        [Bindable(event="dataChange")]
        public function get smoothScrollingEnabled():Boolean {
            return settingsData.smoothScrollingEnabled;
        }


        public function set smoothScrollingEnabled(value:Boolean):void {
            settingsData.smoothScrollingEnabled = value;
            dispatchEvent(new Event("dataChange"));
            writeSettings();
        }


        [Bindable(event="dataChange")]
        public function get fulltextFilterEnabled():Boolean {
            return settingsData.fulltextFilterEnabled;
        }


        public function set fulltextFilterEnabled(value:Boolean):void {
            settingsData.fulltextFilterEnabled = value;
            dispatchEvent(new Event("dataChange"));
            writeSettings();
        }


        [Bindable(event="dataChange")]
        public function get windowProperies():Rectangle {
            return new Rectangle(
                settingsData.x,
                settingsData.y,
                settingsData.width,
                settingsData.height
            );
        }


        public function set windowProperies(value:Rectangle):void {
            settingsData.x = value.x;
            settingsData.y = value.y;
            settingsData.width = value.width;
            settingsData.height = value.height;
            dispatchEvent(new Event("dataChange"));
            writeSettings();
        }


        [Bindable(event="dataChange")]
        public function get contextViewProperties():Rectangle {
            return new Rectangle(
                0, 0,
                settingsData.contextWidth,
                settingsData.contextHeight
            );
        }


        public function set contextViewProperties(value:Rectangle):void {
            settingsData.contextWidth = value.width;
            settingsData.contextHeight = value.height;
            dispatchEvent(new Event("dataChange"));
            writeSettings();
        }


        [Bindable(event="dataChange")]
        public function get backgroundType():String {
            return settingsData.background;
        }


        public function set backgroundType(value:String):void {
            settingsData.background = value;
            dispatchEvent(new Event("dataChange"));
            writeSettings();
        }


        public function Settings() {
            if (_instance) {
                throw new Error("Always use Settings.getInstance() instead of creation");
            }

            sharedObj = SharedObject.getLocal("ru.koldoon.flexsos");
            settingsData = sharedObj.data.settings || defaultSettings();
            dispatchEvent(new Event("dataChange"));
        }


        private static function defaultSettings():Object {
            return {
                "wordWrapEnabled":        true,
                "autoScrollEnabled":      true,
                "transparencyEnabled":    false,
                "smoothScrollingEnabled": false,
                "contextWidth":           350,
                "contextHeight":          220,
                "x":                      50,
                "y":                      50,
                "width":                  1400,
                "height":                 930,
                "background":             BACKGROUND_TYPE_BLACK
            }
        }


        private function writeSettings():void {
            if (sharedObj) {
                try {
                    sharedObj.data.settings = settingsData;
                    sharedObj.flush();
                }
                catch (e:Error) { }
            }
        }
    }
}
