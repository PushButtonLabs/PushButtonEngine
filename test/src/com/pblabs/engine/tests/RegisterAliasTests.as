package com.pblabs.engine.tests
{
    import com.pblabs.engine.PBE;
    import com.pblabs.engine.entity.IEntity;
    import com.pblabs.engine.entity.allocateEntity;
    
    import flexunit.framework.Assert;
    
    import mx.core.UIComponent;
    
    import org.fluint.uiImpersonation.UIImpersonator;
    
    /**
     * Unit test for registerAlias and unregisterAlias functionality on NameManager 
     **/
    public class RegisterAliasTests
    {		
        
        
        [Test]
        public function testRegisterAlias():void{
            var entity:IEntity = allocateEntity();
            entity.initialize("testEntity");
            
            Assert.assertNull(PBE.nameManager.lookup("testAlias"));
            
            //Register the alias and check if lookups work ok
            PBE.nameManager.registerAlias(entity, "testAlias");
            PBE.nameManager.registerAlias(entity, "testAlias2");
            Assert.assertEquals(entity, PBE.nameManager.lookup("testAlias"));
            Assert.assertEquals(entity, PBE.nameManager.lookup("testAlias2"));
            
            //Unregister the alias
            PBE.nameManager.unregisterAlias(entity, "testAlias");
            Assert.assertNull(PBE.nameManager.lookup("testAlias"));
            Assert.assertEquals(entity, PBE.nameManager.lookup("testAlias2"));
            PBE.nameManager.unregisterAlias(entity, "testAlias2");
            Assert.assertNull(PBE.nameManager.lookup("testAlias2"));
            
            //Try to unregister the entityname, this should not remove the entity registration
            PBE.nameManager.unregisterAlias(entity, "testEntity");
            Assert.assertEquals(entity, PBE.nameManager.lookup("testEntity"));
            
            //Re-register the alias and destroy the entity
            PBE.nameManager.registerAlias(entity, "testAlias");
            PBE.nameManager.registerAlias(entity, "testAlias2");
            Assert.assertEquals(entity, PBE.nameManager.lookup("testAlias"));   
            Assert.assertEquals(entity, PBE.nameManager.lookup("testAlias2"));            
            entity.destroy();
            Assert.assertNull(PBE.nameManager.lookup("testAlias"));
            Assert.assertNull(PBE.nameManager.lookup("testAlias2"));    
        }    
    }
}