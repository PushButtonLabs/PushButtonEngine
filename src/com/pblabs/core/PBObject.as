package com.pblabs.core
{
    import com.pblabs.pb_internal;
    
    use namespace pb_internal;
    
    public class PBObject
    {
        public var name:String;
        
        pb_internal var _owningGroup:PBGroup;
        pb_internal var _sets:Vector.<PBSet>;
        
        public function get sets():Vector.<PBSet>
        {
            return _sets;
        }
        
        public function get owningGroup():PBGroup
        {
            return _owningGroup;
        }
        
        public function set owningGroup(value:PBGroup):void
        {
            if(!value)
                throw new Error("A PBObject must always be in a PBGroup.");
            
            if(_owningGroup)
                _owningGroup.noteRemove(this);
            
            _owningGroup = value;
            _owningGroup.noteAdd(this);
        }
        
        pb_internal function noteSetAdd(set:PBSet):void
        {
            if(_sets == null)
                _sets = new Vector.<PBSet>();
            _sets.push(set);            
        }
        
        pb_internal function noteSetRemove(set:PBSet):void
        {
            var idx:int = _sets.indexOf(set);
            if(idx == -1)
                throw new Error("Tried to remove PBObject from a PBSet it didn't know it was in!");
            _sets.splice(idx, 1);            
        }
        
        public function initialize():void
        {
            // Error if not in a group.
            if(_owningGroup == null)
                throw new Error("Can't initialize a PBObject without an owning PBGroup!");
        }
        
        public function destroy():void
        {
            // Remove from sets.
            if(_sets)
            {
                while(_sets.length)
                    _sets[_sets.length-1].remove(this);
            }
            
            // Remove from owning group.
            if(_owningGroup)
            {
                _owningGroup.noteRemove(this);
                _owningGroup = null;                
            }
        }
    }
}