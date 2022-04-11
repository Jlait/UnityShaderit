Shader "Unlit/ProgressShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Angle("Angle", Float) = 0.5

    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }

        Blend SrcAlpha OneMinusSrcAlpha
        ZWrite Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Angle;

            float4 DrawRing(float2 coordinate, float2 texel) {
                float outerEdgeR = 0.15f;
                float innerEdgeR = 0.1f;
                float radius = sqrt(pow((texel.r - coordinate.r), 2) + pow((texel.g - coordinate.g), 2));
                if (outerEdgeR >= radius && innerEdgeR <= radius) {
                    return float4(1, 1, 1, 1);
                }

                else return float4(0, 1, 0, 0);

            }

            float4 DrawRingAngle(float2 coordinate, float2 texel, float angle) {
                float outerEdgeR = 0.5f;
                float innerEdgeR = 0.3f;
                float radius = sqrt(pow((texel.r - coordinate.r), 2) + pow((texel.g - coordinate.g), 2));
                float a = 0;
                
                if (texel.r > coordinate.r) {
                    a = atan((texel.g - coordinate.g) / (texel.r - coordinate.r));

                    if (outerEdgeR >= radius && innerEdgeR <= radius && degrees(a) > -angle) {
                        return float4(0, 0.4f, 0.8f, 1);
                    }

                    else if (outerEdgeR >= radius && innerEdgeR <= radius) {
                        return float4(1, 1, 1, 1);
                    }

                    else return float4(0, 1, 0, 0);
                }

                else {
                    a = atan((texel.g - coordinate.g) / (texel.r - coordinate.r));

                    if (outerEdgeR >= radius && innerEdgeR <= radius && degrees(a) > (-angle+180)) {
                        return float4(0, 0.4f, 0.8f, 1);
                    }

                    else if (outerEdgeR >= radius && innerEdgeR <= radius) {
                        return float4(1, 1, 1, 1);
                    }

                    else return float4(0, 1, 0, 0);
                }

            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = DrawRingAngle(float2(0.5f, 0.5f), i.uv, _Angle);

                return col;
            }
            ENDCG
        }
    }
}
