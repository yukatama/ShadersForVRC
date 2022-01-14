Shader "Yukatama/glslsandbox/71389.0"
{
  SubShader
  {
      Tags { "RenderType" = "Opaque" }
      Cull Off
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
          };

          struct v2f
          {
              float4 vertex : SV_POSITION;
              float2 position : UV;
          };

          sampler2D _MainTex;
          float4 _MainTex_ST;

          v2f vert(appdata v)
          {
              v2f o;
              o.vertex = UnityObjectToClipPos(v.vertex);
              o.position = v.vertex.xy;
              return o;
          }

          // Thanks to great compatibility, GLSL'mod and HLSL's fmod is slightly different.
          float3 mod(float3 x, float y)
          {
              return x - y * floor(x / y);
          }

          float map(float time, float3 p) {
              p.x += 5.0;
              p.z += time * 8.0;
              p = mod(p, 8.0) - 4.0;
              p.xy = abs(p.xy);
              return length(cross(p, float3(0.5, 0.5, 0.5))) - 0.1;
          }

          fixed4 frag(v2f i) : SV_Target
          {
              // converted from http://glslsandbox.com/e#71389.0
              float time = _Time.y;
              float2 surfacePosition = i.position * 2;

              float3 rd = normalize(float3(surfacePosition, 0.5));
              float3 color = float3(0, 0, 0);
              float dist = 0.0;
              for (fixed i = 1; i < 40; i++) {
                  float d = map(time, rd * dist);
                  if (d < 0.001) {
                      color = float3(8 / float(i), 0, 0);
                      break;
                  }
                  dist += d;
              }
              return float4(color, 1);
          }
          ENDCG
      }
  }
}