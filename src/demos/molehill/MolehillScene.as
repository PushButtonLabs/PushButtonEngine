package demos.molehill
{
    import com.pblabs.PBUtil;
    import com.pblabs.core.PBGameObject;
    import com.pblabs.core.PBGroup;
    import com.pblabs.time.ITicked;
    import com.pblabs.time.TimeManager;
    
    import flash.display.Stage;
    import flash.geom.Point;
    
    public class MolehillScene extends PBGroup implements ITicked
    {
        [Inject]
        public var stage:Stage;
        
        public var timeManager:TimeManager = new TimeManager();
        
        public override function initialize():void
        {
            super.initialize();
            
            registerManager(TimeManager, timeManager);
            registerManager(QuadScene, new QuadScene());
            
            for(var i:int=0; i<1000; i++)
                createQuad();
            
            timeManager.addTickedObject(this);
        }
        
        public override function destroy():void
        {
            timeManager.removeTickedObject(this);
            
            super.destroy();
        }
        
        public function createQuad():void
        {
            var go:MolehillGameObject = new MolehillGameObject();
            go.owningGroup = this;
            
            go.render.size = new Point(PBUtil.pickWithBias(10, 100), PBUtil.pickWithBias(10, 100));
            go.render.addBinding("position", "@mover.position");

            go.initialize();
        }
        
        public function onTick():void
        {
            
        }
    }
}