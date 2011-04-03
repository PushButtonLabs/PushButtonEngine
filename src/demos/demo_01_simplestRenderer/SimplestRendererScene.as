package demos.demo_01_simplestRenderer
{
    import com.pblabs.core.PBGroup;
    import com.pblabs.simplest.SimplestSpriteRenderer;
    
    import flash.geom.Point;
    import demos.SimplestDemoGameObject;
    
    /**
     * Very simplest possible demo - a single game object that draws a circle
     * on the stage via a rendering component.
     */
    public class SimplestRendererScene extends PBGroup
    {
        /**
         * Called when the demo scene is created.
         */
        public override function initialize():void
        {
            // Always remember to call the superclass' implementation. It needs
            // to do its own setup logic.
            super.initialize();
            
            // Create a demo object. All game objects derive from PBGameObject
            // and exist to hold subclasses of PBComponent. In PBE, nearly all
            // game logic and behavior lives inside of components.
            var go:SimplestDemoGameObject = new SimplestDemoGameObject();
            
            // Every game object is owned by a group. When the group is destroyed,
            // so are the objects in it. In this way you can clean up when (for
            // instance) a level ends. You will notice we can subclass the group
            // class (PBGroup) to add our own interesting behavior, like spawning
            // certain objects at "level start." This is what is happening in
            // this class, SimplestRendererScene.
            go.owningGroup = this;
            
            // OK - create a renderer and put it on the game object. We'll set
            // the position, too.
            go.render = new SimplestSpriteRenderer();
            go.render.position = new Point(100, 150);

            // Finally, initialize the game object. For game objects with public
            // members that hold components, those components are automatically
            // initialized and registered with the game object under the name
            // of the field. So for instance, our SimplestSpriteRenderer is
            // registered under the name "render" with our new game object.
            go.initialize();
            
            // When the scene is switched out (by the main class, PBEDemos), this
            // group is destroy()ed and the objects in it (ie, the game object
            // we just created) are destroy()ed too. That way we can easily 
            // and reliably clean up after ourselves.
        }
    }
}