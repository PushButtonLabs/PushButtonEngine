package com.pblabs.core
{
    import com.pblabs.pb_internal;
    
    use namespace pb_internal
    
    public class PBSet extends PBObject
    {
        protected var items:Vector.<PBObject> = new Vector.<PBObject>;
        
        public function add(object:PBObject):void
        {
            items.push(object);
            object.noteSetAdd(this);
        }
        
        public function remove(object:PBObject):void 
        {
            var idx:int = items.indexOf(object);
            if(idx == -1)
                throw new Error("Requested PBObject is not in this PBSet.");
            items.splice(idx, 1);
            object.noteSetRemove(this);
        }
        
        public function contains(object:PBObject):Boolean
        {
            return (items.indexOf(object) != -1);
        }
        
        public function get length():int
        {
            return items.length;
        }
        
        public function getPBObjectAt(index:int):PBObject
        {
            return items[index];
        }
    }
}