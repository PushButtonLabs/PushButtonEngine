package com.pblabs.core
{
    import com.pblabs.pb_internal;
    import com.pblabs.property.PropertyManager;
    
    use namespace pb_internal;
    
    /**
     * Base class for most game functionality. Contained in a PBGameObject.
     * 
     * Dependency injection is fulfilled based on the PBGroup containing the
     * owning PBGameObject.
     * 
     * Provides a generic data binding system as well as callbacks when
     * the component is added to or removed from a PBGameObject.
     */
    public class PBComponent
    {
        [Inject]
        public var propertyManager:PropertyManager;
        
        protected var bindings:Vector.<String>;
        
        private var _safetyFlag:Boolean = false;
        private var _name:String;
        
        pb_internal var _owner:PBGameObject;
        
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            if(_owner)
                throw new Error("Already added to PBGameObject, can't change name of PBComponent.");
            
            _name = value;
        }
        
        /**
         * What PBGameObject contains us, if any?
         */
        public function get owner():PBGameObject
        {
            return _owner;
        }
        
        public function addBinding(fieldName:String, propertyReference:String):void
        {
            if(!bindings)
                bindings = new Vector.<String>();
            
            const binding:String = fieldName + "||" + propertyReference;
            
            bindings.push(binding);
        }
        
        public function removeBinding(fieldName:String, propertyReference:String):void
        {
            if(!bindings)
                return;
            
            const binding:String = fieldName + "||" + propertyReference;
            var idx:int = bindings.indexOf(binding);
            if(idx == -1)
                return;
            bindings.splice(idx, 1);
        }
        
        public function applyBindings():void
        {
            if(bindings == null)
                return;
            
            if(!propertyManager)
                throw new Error("Couldn't find a PropertyManager instance, is one available for injection?");
            
            for(var i:int=0; i<bindings.length; i++)
                propertyManager.applyBinding(this, bindings[i]);
        }
        
        pb_internal function doAdd():void
        {
            _safetyFlag = false;
            onAdd();
            if(_safetyFlag == false)
                throw new Error("You forget to call super.onAdd() in an onAdd override.");
        }
        
        pb_internal function doRemove():void
        {
            _safetyFlag = false;
            onRemove();
            if(_safetyFlag == false)
                throw new Error("You forget to call super.onRemove() in an onRemove handler.");
        }
        
        protected function onAdd():void
        {
            _safetyFlag = true;
        }
        
        protected function onRemove():void
        {
            _safetyFlag = true;
        }
    }
}