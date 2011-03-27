package com.pblabs.core
{
    import com.pblabs.pb_internal;
    import com.pblabs.property.PropertyManager;
    import com.pblabs.util.TypeUtility;
    
    import flash.utils.Dictionary;
    
    use namespace pb_internal;
    
    public class PBGameObject extends PBObject
    {
        private var _deferring:Boolean = true;
        private var _components:Dictionary = new Dictionary();
        
        public function get deferring():Boolean
        {
            return _deferring;
        }
        
        public function set deferring(value:Boolean):void
        {
            if(_deferring && value == false)
            {
                var foundDeferred:Boolean = true;
                
                while(foundDeferred)
                {
                    foundDeferred = false;
                    
                    // Initialize deferred components.
                    for(var key:String in _components)
                    {
                        // Normal entries just have alphanumeric.
                        if(key.charAt(0) != "!")
                            continue;
                        
                        // It's a deferral, so init it...
                        doInitialize(_components[key] as PBComponent);
                        
                        // ... and nuke the entry.
                        _components[key] = null;
                        delete _components[key];
                        
                        // Indicate we found stuff so keep looking. Otherwise
                        // we may miss some.
                        foundDeferred = true;
                    }
                }
            }
            
            _deferring = value;
        }
        
        protected function doInitialize(component:PBComponent):void
        {
            component._owner = this;
            owningGroup.injectInto(component);
            component.doAdd();
        }
        
        public function addComponent(component:PBComponent, name:String = null):void
        {
            if(name)
                component.name = name;
            
            if(component.name == null || component.name == "")
                throw new Error("Can't add component with no name.");
            
            // Stuff in dictionary.
            _components[component.name] = component;
            
            // Set component owner.
            component._owner = this;
            
            // Directly set field if present.
            if(hasOwnProperty(component.name))
                this[component.name] = component;
            
            // Defer or add now.
            if(_deferring)
                _components["!" + component.name] = component;
            else
                doInitialize(component);
        }
        
        public function removeComponent(component:PBComponent):void
        {
            if(component.owner != this)
                throw new Error("Tried to remove a component that does not belong to this PBGameObject.");
            
            if(this.hasOwnProperty(component.name) && this[component.name] == component)
                this[component.name] = null;
            
            _components[component.name] = null;
            delete _components[component.name];            
            component.doRemove();
            component._owner = null;
        }
        
        public function lookupComponent(name:String):*
        {
            return _components[name] as PBComponent;
        }
        
        public function getAllComponents():Vector.<PBComponent>
        {
            var out:Vector.<PBComponent> = new Vector.<PBComponent>();
            for(var key:String in _components)
                out.push(_components[key]);
            return out;
        }
        
        public override function initialize():void
        {
            super.initialize();
            
            // Look for un-added members.
            for each(var key:String in TypeUtility.getListOfPublicFields(this))
            {
                // Only consider components.
                if(!(this[key] is PBComponent))
                    continue;
                
                // Don't double initialize.
                if(this[key].owner != null)
                    continue;
                
                // OK, add the component.
                const nc:PBComponent = this[key] as PBComponent;
                
                if(nc.name != null && nc.name != "" && nc.name != key)
                    throw new Error("PBComponent has name '" + nc.name + "' but is set into field named '" + key + "', these need to match!");
                
                nc.name = key;
                addComponent(nc);
            }
            
            // Inject ourselves.
            owningGroup.injectInto(this);
            
            // Stop deferring and let init happen.
            deferring = false;
            
            // Propagate bindings on everything.
            for(var key2:String in _components)
            {
                if(!_components[key2].propertyManager)
                    throw new Error("Failed to inject component properly.");
                _components[key2].applyBindings();
            }
        }
        
        public override function destroy():void
        {
            for(var key:String in _components)
                removeComponent(_components[key]);
            
            super.destroy();
        }
        
        public function getProperty(property:String, defaultValue:* = null):*
        {
            return owningGroup.getManager(PropertyManager).getProperty(this, property, defaultValue);
        }
        
        public function setProperty(property:String, value:*):void
        {
            owningGroup.getManager(PropertyManager).setProperty(this, property, value);            
        }
    }
}