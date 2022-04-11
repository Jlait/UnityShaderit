Shader "Unlit/DownloadShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Angle("Angle", Float) = 0.5
	}
		SubShader
		{
			Tags { "RenderType" = "Transparent" "Queue"="Transparent" }
			LOD 100
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off

					Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				static const float PI = 3.14159265f;
				uniform float2 circles[5];
				uniform int circleCount = 4;

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

				int CirclesRing(float2 coordinate) {
					float r = 0.1f;

					for (int i = 0; i < circleCount; i++) {
						circles[i].r = sin(360 / (i + 1)) * r + coordinate.r;
						circles[i].g = cos(360 / (i + 1)) * r + coordinate.g;
					}
					 return 1;
				 };

				 float4 DrawCircle(float2 coordinate, float2 texel, float4 color) {
					 float r = 0.05f;

					 if (r >=
						 sqrt(pow((texel.r - coordinate.r), 2) + pow((texel.g - coordinate.g),2))
						 ) {
						 return color;
					 }

					 else return float4(0, 0, 0, 0);
				 };

				 float4 DrawCircles(float2 texel) {
					 float r = 0.05f;
					 for (int i = 0; i < circleCount; i++) {
						 if (r >=
							 sqrt(pow((texel.r - circles[i].r), 2) + pow((texel.g - circles[i].g), 2))
							 ) {
							 return float4(1, 1, 1, 1);
						 }
					 }
					 return float4(0, 0, 0, 0);
				 }

				 float4 f2test(float2 proot) {
					 return float4(0, proot.r, proot.g, 1);
				 }

				 sampler2D _MainTex;
				 float4 _MainTex_ST;
				 float _Angle;
				 v2f vert(appdata v)
				 {
					 v2f o;
					 o.vertex = UnityObjectToClipPos(v.vertex);
					 o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					 return o;
				 }

				 fixed4 frag(v2f i) : SV_Target
				 {
					 float4 draw = (0, 0, 0, 0);
					 float r = 0.4f;
					 float angle = _Angle;

					 for (int j = 0; j < 6; j++) {
						 float y = sin((angle - (j * 0.3f))) * r + 0.5f;
						 float x = cos((angle - (j * 0.3f))) * r + 0.5f;

						 float4 color = (1, 1, 1, 1);
						 color = color * (j * 0.4f + 0.1f);
						 draw += DrawCircle(float2(x, y), i.uv, color);
					 }

					 draw = clamp(draw, 0, 1);
					 fixed4 col = draw;
					 return col;
				 }
				 ENDCG
			 }
		}
}