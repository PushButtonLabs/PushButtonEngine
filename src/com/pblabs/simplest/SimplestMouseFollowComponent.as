package com.pblabs.simplest
{
    import com.pblabs.core.PBComponent;
    
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    public class SimplestMouseFollowComponent extends PBComponent
    {
        [Inject]
        public var stage:Stage;

        public var targetProperty:String;
        
        protected override function onAdd():void
        {
            super.onAdd();
            
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
        }
        
        protected function onMove(me:MouseEvent):void
        {
            owner.setProperty(targetProperty, new Point(me.stageX, me.stageY));
        }
        
        protected override function onRemove():void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);

            super.onRemove();
        }
    }
}