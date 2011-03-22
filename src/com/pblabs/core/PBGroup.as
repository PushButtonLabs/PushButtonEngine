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
        protected var items:Vector.<PBObject> = new Vector.<PBObject>();
        protected var injector:Injector = null;
        
        pb_internal function getInjector():Injector
        {
            if(injector)
                return injector;
            else
                return owningGroup.getInjector();
        }
        
        public final function contains(object:PBObject):Boolean
        {
            return (object.owningGroup == this);
        }
        
        public final function get length():int
        {
            return items.length;
        }
        
        public final function getPBObjectAt(index:int):PBObject
        {
            return items[index];
        }
        
        public override function initialize():void
        {
            // Groups can stand alone so don't do the _owningGroup check in the parent class.
            //super.initialize();
            
            // If no owning group, add to the global list for debug purposes.
            if(owningGroup == null)
            {
                PBE._rootGroups.push(this);
            }
            else
            {
                if(injector)
                    injector.setParentInjector(owningGroup.getInjector());

                owningGroup.injectInto(this);                
            }
        }
        
        public override function destroy():void
        {
            // Remove from global list if needed.
            if(owningGroup == null)
            {
                var idx:int = PBE._rootGroups.indexOf(this);
                if(idx == -1)
                {
                    Logger.warn(this, "destroy", "Couldn't find self in the global root group list.");
                }
                else
                {
                    PBE._rootGroups.splice(idx, 1);
                }
            }
            
            super.destroy();
            
            // Wipe the items.
            while(length)
                getPBObjectAt(length-1).destroy();
        }
        
        pb_internal function noteRemove(object:PBObject):void
        {
            // Get it out of the list.
            var idx:int = items.indexOf(object);
            if(idx == -1)
                throw new Error("Can't find PBObject in PBGroup! Inconsistent group membership!");
            items.splice(idx, 1);
        }
        
        pb_internal function noteAdd(object:PBObject):void
        {
            items.push(object);
        }
        
        //---------------------------------------------------------------
                
        protected function initInjection():void
        {
            if(injector)
                return;
            
            injector = new Injector();
                        
            if(owningGroup)
                injector.setParentInjector(owningGroup.getInjector());
        }
        
        public function registerManager(clazz:Class, instance:*):void
        {
            initInjection();
            
            injector.mapValue(instance, clazz);

            injector.apply(instance);
        }
        
        public function getManager(clazz:Class):*
        {
            var res:* = null;
            
            res = getInjector().getMapping(clazz);

            if(!res)
                throw new Error("Can't find manager " + clazz + "!");
            
            return res;
        }

        public function injectInto(object:*):void
        {
            getInjector().apply(object);
        }
        
        public function lookup(name:String):PBObject
        {
            return owningGroup.lookup(name);
        }
    }
}