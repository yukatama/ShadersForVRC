Shader "Yukatama/shadertoy/MsjSW3"
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

          float2x2 m(float a) { float c = cos(a), s = sin(a); return float2x2(c, -s, s, c); }
          float map(float t, float3 p) {
            p.xz = mul(p.xz, m(t*0.4));
            p.xy * mul(p.xy, m(t*0.3));
            float3 q = p * 2. + t;
            float s = sin(t*0.7);
            return length(p + float3(s,s,s))
                *log(length(p) + 1.) + sin(q.x + sin(q.z + sin(q.y)))*0.5 - 1.;
          }

          fixed4 frag(v2f i) : SV_Target
          {
              // converted from https://www.shadertoy.com/view/MsjSW3
              float iTime = _Time.x * 10;
              float2 iResolution = float2(1920, 1040);
              float2 fragCoord = (i.position + float2(0.5, 0.5)) * iResolution;

              float2 p = fragCoord.xy / iResolution.y - float2(.9, .5);
              float3 cl = float3(0,0,0);
              float d = 2.5;
              for (int i = 0; i <= 5; i++) {
                float3 p3 = float3(0, 0, 5.) + normalize(float3(p.x, p.y, -1.))*d;
                float rz = map(iTime, p3);
                float f = clamp((rz - map(iTime, p3 + .1))*0.5, -.1, 1.);
                float3 l = float3(0.1, 0.3, .4) + float3(5., 2.5, 3.)*f;
                cl = cl * l + smoothstep(2.5, .0, rz)*.7*l;
                d += min(rz, 1.);
              }
              return float4(cl, 1.);
          }
          ENDCG
      }
  }
}
