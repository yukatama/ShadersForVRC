Shader "Yukatama/FutureDress"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull Off
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 position : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.position = v.vertex.xyz;
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) / 2;

                float t = _Time.y;
                float3 pos = fixed3(i.position.x / 0.003, (i.position.z - 0.1) / 0.005, abs(i.position.y / 0.003));
                float yr = ((t * 25) % 100) - 50;
                float lr = 1 / abs(pos.y - yr) * 2 * pos.z * 0.2;
                float yg = ((t * 12) % 100) - 50;
                float lg = 1 / abs(pos.y - yg) * 1.3 * pos.z * 0.3;
                float yb = ((t * 10) % 100) - 50;
                float lb = 1 / abs(pos.y - yb) * 3 * pos.z * 0.14;
                float yc = ((t * 17) % 100) - 50;
                float lc = 1 / abs(pos.y - yc) * 1.1 * pos.z * 0.1;
                float ym = ((t * 7) % 100) - 50;
                float lm = 1 / abs(pos.y - ym) * 1.7 * pos.z * 0.13;
                float yy = ((t * 21) % 100) - 50;
                float ly = 1 / abs(pos.y - yy) * 3.3 * pos.z * 0.17;
                col += fixed4(lr + lm + ly, lg + lc + ly, lb + lc + lm, 1) / 10;
            
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
