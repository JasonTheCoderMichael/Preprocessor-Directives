Shader "MJ/PreprocessorDirective"
{
    Properties
    {
        [KeywordEnum(None, If, Ifdef, Defined)] _DirectiveType("Preprocessor directive type", int) = 0
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            #pragma shader_feature _DIRECTIVETYPE_NONE _DIRECTIVETYPE_IF _DIRECTIVETYPE_IFDEF _DIRECTIVETYPE_DEFINED

            // 可以通过开启或关闭以下一个或多个宏的声明 和 材质球界面选择的 preprocessor directive type 选项来查看效果 //
            // 没有任何一个分支没执行时输出黑色 //
            #define WHITE
            #define RED 0
            #define BLUE 2

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                #if defined(_DIRECTIVETYPE_NONE)
                {
                    return float4(0,0,0,1);
                }
                // 使用 #if //
                #elif defined(_DIRECTIVETYPE_IF)
                {
                    // #if WHITE               // 会报错, invalid or unsupported integer constant expression //
                    #if RED
                    {
                        return float4(1,0,0,1);
                    }
                    #elif BLUE      // 还可以使用 #elif BLUE>1 之类的表达式 //
                    {
                        return float4(0,0,1,1);
                    }
                    #else
                    {
                        return float4(0,0,0,1);
                    }
                    #endif
                }
                // 使用 #ifdef //
                #elif defined(_DIRECTIVETYPE_IFDEF)
                {
                    #ifdef WHITE
                    {
                        return float4(1,1,1,1);
                    }
                    #endif
                    
                    #ifdef RED
                    {
                        return float4(1,0,0,1);
                    }
                    #endif

                    #ifdef BLUE
                    {
                        return float4(0,0,1,1);
                    }
                    #endif

                    return float4(0,0,0,1);
                }
                // 使用 #if defined //
                #elif defined(_DIRECTIVETYPE_DEFINED)
                {
                    #if defined(WHITE)
                    {
                        return float4(1,1,1,1);
                    }
                    #elif defined(RED)
                    {
                        return float4(1,0,0,1);
                    }
                    #elif defined(BLUE)
                    {
                        return float4(0,0,1,1);
                    }
                    #endif

                    return float4(0,0,0,1);
                }
                #endif
            }
            ENDCG
        }
    }
}