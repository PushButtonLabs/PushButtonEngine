package com.pblabs
{
    import com.pblabs.core.PBGroup;
    
    import flash.display.Stage;

    /**
     * Helper class to track a few important bits of global state.
     */
    public class PBE
    {
        public static const IS_SHIPPING_BUILD:Boolean = false;
        
        pb_internal static var _rootGroup:PBGroup = new PBGroup("_RootGroup");
    }
}