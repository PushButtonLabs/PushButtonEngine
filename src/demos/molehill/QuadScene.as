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
    import flash.display3D.Context3DProgramType;
    import flash.display3D.Context3DRenderMode;
    import flash.display3D.Context3DTextureFormat;
    import flash.display3D.Context3DVertexBufferFormat;
    import flash.display3D.IndexBuffer3D;
    import flash.display3D.Program3D;
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
        protected var curVertex:int = 0;
        protected var indices:Vector.<uint> = new Vector.<uint>();
        protected var curIndex:int = 0;
        
        public const MAX_QUADS:int = 8192;
        
        protected var vb:VertexBuffer3D;
        protected var ib:IndexBuffer3D;
        protected var _shaderProgram:Program3D;
        
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
            const stageWidthScale:Number = Number(stage.stageWidth*0.5);
            const stageHeightScale:Number = Number(stage.stageHeight*0.5);

            // Vertex 0.
            vertices[curVertex*6+0] = ((x - w * 0.5) / stageWidthScale) - 1;
            vertices[curVertex*6+1] = ((y - h * 0.5) / stageHeightScale) - 1;
            vertices[curVertex*6+2] = 0.5;
            
            vertices[curVertex*6+3] = 0;
            vertices[curVertex*6+4] = 1;
            vertices[curVertex*6+5] = 0;
            curVertex++;
            
            // Vertex 1.
            vertices[curVertex*6+0] = ((x + w * 0.5) / stageWidthScale) - 1;
            vertices[curVertex*6+1] = ((y - h * 0.5) / stageHeightScale) - 1;
            vertices[curVertex*6+2] = 0.5;
            
            vertices[curVertex*6+3] = 1;
            vertices[curVertex*6+4] = 1;
            vertices[curVertex*6+5] = 0;
            curVertex++;
            
            // Vertex 2.
            vertices[curVertex*6+0] = ((x + w * 0.5) / stageWidthScale) - 1;
            vertices[curVertex*6+1] = ((y + h * 0.5) / stageHeightScale) - 1;
            vertices[curVertex*6+2] = 0.5;
            
            vertices[curVertex*6+3] = 0;
            vertices[curVertex*6+4] = 1;
            vertices[curVertex*6+5] = 1;
            curVertex++;
            
            // Vertex 3.
            vertices[curVertex*6+0] = ((x - w * 0.5) / stageWidthScale) - 1;
            vertices[curVertex*6+1] = ((y + h * 0.5) / stageHeightScale) - 1;
            vertices[curVertex*6+2] = 0.5;
            
            vertices[curVertex*6+3] = 1;
            vertices[curVertex*6+4] = 0;
            vertices[curVertex*6+5] = 1;
            curVertex++;
            
            if((curVertex/4) > MAX_QUADS)
                throw new Error("Exceed max quad count!");
        }
        
        public function onFrame():void
        {
            // Clear the framebuffer.
            context3D.clear();
            
            // Draw some dynamic quads.
            vb.uploadFromVector(vertices, 0, curVertex);
            context3D.setVertexBufferAt(0, vb, 0, Context3DVertexBufferFormat.FLOAT_3);
            context3D.setVertexBufferAt(1, vb, 3, Context3DVertexBufferFormat.FLOAT_3);
            context3D.setProgram(_shaderProgram);
            context3D.drawTriangles(ib, 0, (curVertex/4)*6);
            
            // Clean up.
            context3D.setVertexBufferAt(0, null);
            context3D.setVertexBufferAt(1, null);
            context3D.setProgram(null);
            
            // Reset buffer.
            curVertex = 0;
            
            // Present.
            context3D.present();
        }
        
        private function stageNotificationHandler(e:Event):void
        {
            context3D = stage3D.context3D;
            initContext3D();	
        }
        
        private function initShaders(_context:Context3D):void
        {
            var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
            vertexShaderAssembler.assemble( Context3DProgramType.VERTEX, "mov v0, va1\nmov op, va0" );
            
            var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler(); 
            fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT, "mov oc, v0");
            
            _shaderProgram = _context.createProgram();
            _shaderProgram.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode );			
        }
        
        private function initContext3D():void
        {
            context3D.enableErrorChecking = false;
            context3D.configureBackBuffer( stage.stageWidth, stage.stageHeight, 0, true); 
            context3D.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
            
            // Set up our dynamic vertex buffer.
            vb = context3D.createVertexBuffer(MAX_QUADS*4,6);
            
            vertices.length = MAX_QUADS * 4 * 6;
            vertices.fixed = true;
            
            // Set up our index buffer once.
            ib = context3D.createIndexBuffer(MAX_QUADS*6);
            
            indices.length = MAX_QUADS * 6;
            indices.fixed = true;
            curIndex = 0;
            for(var i:int=0; i<MAX_QUADS; i++)
            {
                indices[curIndex++] = i * 4 + 0; 
                indices[curIndex++] = i * 4 + 1; 
                indices[curIndex++] = i * 4 + 2; 

                indices[curIndex++] = i * 4 + 2; 
                indices[curIndex++] = i * 4 + 3; 
                indices[curIndex++] = i * 4 + 0; 
            }
            ib.uploadFromVector(indices, 0, indices.length);
            
            // Initialize a simple shader.
            initShaders(context3D);
            
            // Start up in a clear state.
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