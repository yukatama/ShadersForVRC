Shader "Yukatama/shadertoy/ttdBRf"
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

#define R(p,a,r)lerp(a*dot(p,a),p,cos(r))+sin(r)*cross(p,a)
#define H(h)cos(h*6.3+float3(0,23,21))*.5+.5

          fixed4 frag(v2f i) : SV_Target
          {
              // converted from https://www.shadertoy.com/view/ttdBRf
              float iTime = _Time.x * 10;
              float2 iResolution = float2(1920, 1040);
              float2 C = (i.position + float2(0.5, 0.5)) * iResolution;

              float4 O = float4(0, 0, 0, 0);
              float3 r = float3(iResolution, 1), p;
              for (float i = 0, g = 0, e = 0, s = 0; ++i < 99.;) {
                  p = g * float3((C - .5*r.xy) / r.y, 1);
                  p.z -= 6.;
                  p = R(p, normalize(float3(1, 1, 0)), iTime*.3);
                  p.y -= .5;
                  p.xz = float2(atan2(p.z, p.x), length(p.xz) - 2.5);

                  // Added at Lumos request
#if 1
                  if (length(p.yz) < .5)p = R(p, float3(1, 0, 0), -iTime);
                  else if (length(p.yz) < 1.2)p = R(p, float3(1, 0, 0), iTime);
#else
                  if (length(p.yz) < .5)p.x -= iTime;
                  else if (length(p.yz) < 1.2)p.x += iTime;;
                  p.x = mod(p.x, 6.28) - 3.14;
#endif
                  // -----------------------

                  p.yz = float2(atan2(p.z, p.y), length(p.yz) - 1.);
                  p.z = abs(p.z) - .3;
                  p.z = abs(p.z) - .3;
                  s = 3.;
                  for (int j = 0; j++ < 8;) {
                      e = 2.3 / clamp(dot(p, p), .1, 1.6);
                      s *= e;
                      p = abs(p)*e - float3(6.5, 2, .005);
                  }
                  e = length(p.xz) / s;
                  g += e;
                  if (e < .002)
                      O.xyz += lerp(r / r, H(log(s)*.25), .7)*1. / i;
              }
              return O;
          }
          ENDCG
      }
  }
}
