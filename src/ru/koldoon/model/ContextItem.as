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
    public class ContextItem
    {
        public var label:String;
        public var count:int;


        public function ContextItem(label:String, count:int = 0)
        {
            this.label = label;
            this.count = count;
        }
    }
}
