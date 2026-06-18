class CfgPatches {
    class trf_ukaf_ace_sleeves_gloves_main {
        name = "[TRF] UKAF ACE Sleeves & Gloves";
        author = "OpenAI Codex";
        requiredVersion = 2.14;
        requiredAddons[] = {
            "cba_main",
            "ace_common",
            "ace_interact_menu"
        };
        units[] = {};
        weapons[] = {};
    };
};

class CfgFunctions {
    class TRF_UKAF_ACE_Sleeves_Gloves {
        tag = "TRF_UKAF_ACE_Sleeves_Gloves";

        class main {
            file = "\z\trf_ukaf_ace_sleeves_gloves\addons\main\functions";

            class buildVariantAction {};
            class buildVariantActions {};
            class getCurrentOptions {};
            class getUniformOptions {};
            class hasSupportedUniform {};
            class playTransitionSound {};
            class postInit {
                postInit = 1;
            };
            class registerSettings {};
            class startUniformTransition {};
            class switchUniformVariant {};
        };
    };
};
