package demos.molehill
{
    import com.pblabs.core.PBGroup;
    import com.pblabs.time.ITicked;
    import com.pblabs.time.TimeManager;
    
    import flash.display.Stage;
    
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
            
            timeManager.addTickedObject(this);
        }
        
        public override function destroy():void
        {
            timeManager.removeTickedObject(this);
            
            super.destroy();
        }
        
        public function onTick():void
        {
            
        }
    }
}