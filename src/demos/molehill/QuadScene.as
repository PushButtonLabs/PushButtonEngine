package demos.molehill
{
    import com.pblabs.core.IPBManager;
    import com.pblabs.time.IAnimated;
    import com.pblabs.time.TimeManager;
    
    import flash.display.BitmapData;
    import flash.display.Stage;
    import flash.display.Stage3D;
    import flash.display3D.Context3D;
    import flash.display3D.Context3DBlendFactor;
    import flash.display3D.Context3DCompareMode;
    import flash.display3D.Context3DRenderMode;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.VertexBuffer3D;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;
    
    public class QuadScene implements IAnimated, IPBManager
    {
        [Inject]
        public var stage:Stage;
        
        [Inject]
        public var timeManager:TimeManager; 
        
        public var stage3D:Stage3D;        
        public var context3D:Context3D;
        
        protected var textures:Dictionary = new Dictionary();
        
        protected var currentTex:String = null;
        protected var vertices:Vector.<Number> = new Vector.<Number>();
        protected var indices:Vector.<uint> = new Vector.<uint>(); 
        
        protected var vb:VertexBuffer3D;
        protected var ib:IndexBuffer3D;
        
        public function registerTexture(name:String, bits:BitmapData):void
        {
            const te:TextureEntry = new TextureEntry();
            te.name = name;
            te.bits = bits;
            te.tex = context3D.createTexture(bits.width, bits.height, Context3DTextureFormat.BGRA, false);
            te.tex.uploadFromBitmapData(te.bits);
        }
        
        public function addQuad(texName:String, x:Number, y:Number, w:Number, h:Number, th:Number):void
        {
            // 0----1
            // |    |
            // 3----2
            
            // Emit vertices.
            const startIdx:int = vertices.length;
            vertices.push( x - w * 0.5, y - h * 0.5 );
            vertices.push( x + w * 0.5, y - h * 0.5 );
            vertices.push( x + w * 0.5, y + h * 0.5 );
            vertices.push( x - w * 0.5, y + h * 0.5 );
            
            // Emit triangles.
            indices.push(startIdx+0);
            indices.push(startIdx+1);
            indices.push(startIdx+2);
            
            indices.push(startIdx+2);
            indices.push(startIdx+3);
            indices.push(startIdx+0);
        }
        
        public function onFrame():void
        {
            vb.uploadFromVector(vertices, 0, vertices.length/3);
            ib.uploadFromVector(indices, 0, indices.length);
            context3D.setVertexBufferAt(0, vb, 0, Context3DVertexBufferFormat.FLOAT_2);
            context3D.drawTriangles(ib, 0, indices.length / 6);
            context3D.setVertexBufferAt(0, null);
        }
        
        private function stageNotificationHandler(e:Event):void
        {
            context3D = stage3D.context3D;
            initContext3D();	
        }
        
        private function initContext3D():void
        {
            context3D.enableErrorChecking = false;
            context3D.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, true); 
            context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            context3D.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);
            
            vb = context3D.createVertexBuffer(4096, 3);
            ib = context3D.createIndexBuffer(4096*6);
            
            context3D.clear(0, 0, 1);
            context3D.present();
        }
        
        public function initialize():void
        {
            stage3D = stage.stage3Ds[0];
            
            stage3D.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            context3D = stage3D.context3D;
            if(context3D == null)
            {
                stage3D.addEventListener ( Event.CONTEXT3D_CREATE, stageNotificationHandler,false,0,true);
                stage3D.requestContext3D ( Context3DRenderMode.AUTO );										
            }
            else
            {
                initContext3D();
            }
            
            timeManager.addAnimatedObject(this, -10.0);
        }
        
        public function destroy():void
        {
            timeManager.removeAnimatedObject(this);

            if(context3D)
                context3D.dispose();
            stage.invalidate();
        }
    }
}

import flash.display.BitmapData;
import flash.display3D.textures.Texture;

class TextureEntry
{
    public var name:String;
    public var tex:Texture;
    public var bits:BitmapData;
}