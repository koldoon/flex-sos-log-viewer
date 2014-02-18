/**
 * @author Vadim Usoltsev
 * @version $Id$
 *          $LastChangedDate$
 *          $Author$
 *          $Date$
 *          $Rev$
 */
package ru.koldoon.model
{
    import mx.utils.StringUtil;

    import ru.koldoon.tools.leadingZero;

    [Bindable]
    public class LogItem
    {
        private var _message:String;
        private var _time:uint;

        public var key:String;
        public var lineMessage:String;
        public var category:String;
        public var folded:Boolean;
        public var timeString:String;


        public function get message():String
        {
            return _message;
        }

        public function set message(value:String):void
        {
            _message = value;
            var lines:Array = _message.split("\n");
            lineMessage = lines[0];
            folded = lines.length > 1;
        }

        public function get time():uint
        {
            return _time;
        }

        public function set time(value:uint):void
        {
            _time = value;
            var date:Date = new Date(_time);
            timeString = StringUtil.substitute(
                    "{0}:{1}:{2} '{3}",
                    leadingZero(date.hours),
                    leadingZero(date.minutes),
                    leadingZero(date.seconds),
                    date.milliseconds
            );
        }
    }
}
