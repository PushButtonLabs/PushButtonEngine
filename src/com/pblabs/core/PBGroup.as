package com.pblabs.core
{
    import com.pblabs.PBE;
    import com.pblabs.debug.Logger;
    import com.pblabs.pb_internal;
    import com.pblabs.util.Injector;
    
    import flash.utils.Dictionary;
    
    use namespace pb_internal;
    
    public class PBGroup extends PBObject
    {
        protected var _items:Vector.<PBObject> = new Vector.<PBObject>();
        protected var _injector:Injector = null;
        
        pb_internal function get injector():Injector
        {
            if(_injector)
                return _injector;
            else if(owningGroup)
                return owningGroup.injector;
            return null;
        }
        
        public final function contains(object:PBObject):Boolean
        {
            return (object.owningGroup == this);
        }
        
        public final function get length():int
        {
            return _items.length;
        }
        
        public final function getPBObjectAt(index:int):PBObject
        {
            return _items[index];
        }
        
        public override function initialize():void
        {
            // Groups can stand alone so don't do the _owningGroup check in the parent class.
            //super.initialize();
            
            // If no owning group, add to the global list for debug purposes.
            if(owningGroup == null)
            {
                owningGroup = PBE._rootGroup;
            }
            else
            {
                if(_injector)
                    _injector.setParentInjector(owningGroup.injector);
                
                owningGroup.injectInto(this);                
            }
        }
        
        public override function destroy():void
        {
            super.destroy();
            
            // Wipe the items.
            while(length)
                getPBObjectAt(length-1).destroy();
            
            // Shut down the managers we own.
            if(_injector)
            {
                for(var key:* in _injector.mappedValues)
                {
                    const val:* = _injector.mappedValues[key];
                    if(val is IPBManager)
                        (val as IPBManager).destroy();
                }
            }
        }
        
        pb_internal function noteRemove(object:PBObject):void
        {
            // Get it out of the list.
            var idx:int = _items.indexOf(object);
            if(idx == -1)
                throw new Error("Can't find PBObject in PBGroup! Inconsistent group membership!");
            _items.splice(idx, 1);
        }
        
        pb_internal function noteAdd(object:PBObject):void
        {
            _items.push(object);
        }
        
        //---------------------------------------------------------------
        
        protected function initInjection():void
        {
            if(_injector)
                return;
            
            _injector = new Injector();
            
            if(owningGroup)
                _injector.setParentInjector(owningGroup.injector);
        }
        
        public function registerManager(clazz:Class, instance:*):void
        {
            initInjection();
            _injector.mapValue(instance, clazz);
            _injector.apply(instance);
            
            if(instance is IPBManager)
                (instance as IPBManager).initialize();
        }
        
        public function getManager(clazz:Class):*
        {
            var res:* = null;
            
            res = injector.getMapping(clazz);
            
            if(!res)
                throw new Error("Can't find manager " + clazz + "!");
            
            return res;
        }
        
        public function injectInto(object:*):void
        {
            injector.apply(object);
        }
        
        public function lookup(name:String):PBObject
        {
            return owningGroup.lookup(name);
        }
    }
}