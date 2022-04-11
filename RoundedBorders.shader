Shader "Unlit/RoundedBorders"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Radius("Radius", Float) = 0.5
        _Color("Color", Color) = (1, 1, 1, 1)
    }
        SubShader
        {
                Tags {
                "RenderType" = "Transparent"
                "Queue" = "Transparent"
                }
                Blend SrcAlpha OneMinusSrcAlpha
            LOD 100

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
            uniform float4 _Color;
            uniform float _Radius;
            
            uniform float2 corners[4] = {
                float2(0,0),
                float2(1,0),
                float2(0,1),
                float2(1,1) 
            };
            
            float4 DrawRectangle(float2 texel) {
                float r = _Radius;
                corners[0] = float2(0.2f, 0.2f);
                corners[1] = float2(0.8f, 0.2f);
                corners[2] = float2(0.2f, 0.8f);
                corners[3] = float2(0.8f, 0.8f);

                
                if (texel.x >= corners[0].x - r && texel.x <= corners[1].x + r&&
                    texel.y >= 0.2f && texel.y <= 0.8f
                    ) {
                    return _Color;
                }

                else if (texel.x >= 0.2f && texel.x <= 0.8f &&
                    texel.y >= corners[0].y - r && texel.y <= corners[2].y + r
                    ) {
                    return _Color;
                }


                for (int j = 0; j < 4; j++) {
                    if (r >=
                        sqrt(pow((texel.r - corners[j].x), 2) + pow((texel.g - corners[j].y), 2))
                        ) {
                        return _Color;
                    }
                }

                return float4(0, 0, 0, 0);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float r = _Radius;

                corners[0] = float2(0.2f, 0.2f);
                corners[1] = float2(0.8f, 0.2f);
                corners[2] = float2(0.2f, 0.8f);
                corners[3] = float2(0.8f, 0.8f);

                float4 color = DrawRectangle(i.uv);
                fixed4 col = color;
                return col;
            }
            ENDCG
        }
    }
}
