/**
 * @author Vadim Usoltsev
 * @version $Id$
 *          $LastChangedDate$
 *          $Author$
 *          $Date$
 *          $Rev$
 */
package ru.koldoon.model {
    import flash.events.Event;

    public class LogEvent extends Event {
        public static const MSG:String = "messageRecieved";

        public var logItem:LogItem;


        public function LogEvent(type:String) {
            super(type);
            this.logItem = new LogItem();
        }
    }
}
