package com.pblabs.engine.tests
{
    import com.pblabs.engine.PBE;
    import com.pblabs.engine.entity.IEntity;
    
    import flexunit.framework.Assert;

    public class InstantiateTemplateWithEntityNameTests
    {		
        
        public var templateXML:XML = <template name="testTemplate" />;
        public var entityXML:XML = <entity name="testEntity" />;

        [Test]
        public function testInstantiateTemplateWithEntityName():void{
            //Register xml templates to test with
            PBE.templateManager.addXML(templateXML, "testTemplateXML", 0);
            PBE.templateManager.addXML(entityXML, "testEntityXML", 0);
            
            var entity:IEntity;
            
            //Test the default behaviour
            entity = PBE.templateManager.instantiateEntity("testTemplate");
            Assert.assertEquals("", entity.name);
            entity.destroy();
            
            //Test whether the entity name is used upon a template
            entity = PBE.templateManager.instantiateEntity("testTemplate", "entityName");
            Assert.assertEquals("entityName", entity.name);
            entity.destroy();
            
            //Test the default behaviour for an entity
            entity = PBE.templateManager.instantiateEntity("testEntity");
            Assert.assertEquals("testEntity", entity.name);
            entity.destroy();    
            
            //Test whether the entityname is not overriden when passing an entityName
            entity = PBE.templateManager.instantiateEntity("testEntity", "overrideEntityName");
            Assert.assertEquals("testEntity", entity.name);
            entity.destroy();              
            
            //Cleanup xml
            PBE.templateManager.removeXML("testTemplateXML");
            PBE.templateManager.removeXML("testEntityXML");
        }
    }
}