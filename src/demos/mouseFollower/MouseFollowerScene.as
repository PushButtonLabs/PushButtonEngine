package demos.mouseFollower
{
    import com.pblabs.core.PBGroup;
    import com.pblabs.simplest.SimplestMouseFollowComponent;
    import com.pblabs.simplest.SimplestSpatialComponent;
    import com.pblabs.simplest.SimplestSpriteRenderer;
    import demos.SimplestDemoGameObject;
    
    /**
     * Simple scene which shows how to make a game object that follows the mouse. 
     */
    public class MouseFollowerScene extends PBGroup
    {
        public override function initialize():void
        {
            super.initialize();

            // Just create our object. We pull it into its own subroutine
            // for clarity.
            createPartyObject();
        }
        
        /**
         * Helper function to create an object for our demo.
         */
        protected function createPartyObject():void
        {
            // Create a party object.
            var go:SimplestDemoGameObject = new SimplestDemoGameObject();
            go.owningGroup = this;
            
            // Set up the spatial.
            go.spatial = new SimplestSpatialComponent();
            
            // Initialize the renderer - notice this is identical to the example
            // in BindingDemoScene.
            go.render = new SimplestSpriteRenderer();
            go.render.addBinding("position", "@spatial.position");
            
            // Now, let's add the new part - a component which is designed to set
            // a specified property every frame. The SimplestMouseFollowComponent
            // reads the mouse's position and sets the specified property each
            // frame.
            const mfc:SimplestMouseFollowComponent = new SimplestMouseFollowComponent();
            mfc.targetProperty = "@spatial.position";
            
            // Since we don't have a field on the SimplestPartyGameObject for
            // this component, we can add it in the generic way, ie, by using
            // addComponent.
            go.addComponent(mfc, "mouse");
            
            // Let the object live and be free!
            go.initialize();
        }
    }
}