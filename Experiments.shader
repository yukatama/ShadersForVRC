Shader "Yukatama/Experiments"
{
    Properties
    {
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

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : POSITION;
                float3 position : TEXCOORD;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.position = v.vertex.xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float t = _Time.y;
                float3 pos = i.position / 0.003;
                pos += fixed3(0, -25, 0);
                float stage = t % 5;
                if (stage < 1) {
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

                    return fixed4(lr + lm + ly, lg + lc + ly, lb + lc + lm, 1);
                } else if (stage < 2) {
                    float l = 0.1 * pos.z * abs(sin(pos.y / 50 + t * 5));
                    return fixed4(l, l, l, 1);
                } else if (stage < 3) {
                    float yr = sin(t * 3 + pos.x * 0.1) * 27;
                    float lr = 4 / abs(pos.y - yr) * pos.z;
                    float yg = sin(t * 2 + pos.x * 0.3) * 23;
                    float lg = 2 / abs(pos.y - yg) * pos.z;
                    float yb = sin(t * 1 + pos.x * 0.7) * 20;
                    float lb = 1 / abs(pos.y - yb) * pos.z;
                    return fixed4(lr, lg, lb, 1);
                } else if (stage < 4) {
                    float r = sin(t * 3 + pos.x);
                    float g = sin(t * 7 + pos.y);
                    float b = sin(t * 11 + pos.z);
                    return fixed4(r, g, b, 1);
                } else {
                    float r1 = sin(t * 3);
                    float g1 = sin(t * 5);
                    float b1 = sin(t * 7);
                    float rad = sin(t * 11) * 3; 
                    float tx1 = cos(t) * 10 * rad;
                    float ty1 = sin(t) * 10 * rad;
                    float d21 = pow(tx1 - pos.x, 2) + pow(ty1 - pos.y, 2);
                    float l1 = 10 / sqrt(d21 * 10);

                    float r2 = sin(t * 3 + 100);
                    float g2 = sin(t * 5 + 100);
                    float b2 = sin(t * 7 + 100);
                    float tx2 = cos(t - 3000) * 10 * rad;
                    float ty2 = sin(t - 3000) * 10 * rad;
                    float d22 = pow(tx2 - pos.x, 2) + pow(ty2 - pos.y, 2);
                    float l2 = 10 / sqrt(d22 * 10);
                    float tx3 = cos(t - 6000) * 10 * rad;
                    float ty3 = sin(t - 6000) * 10 * rad;
                    float d23 = pow(tx3 - pos.x, 2) + pow(ty3 - pos.y, 2);
                    float l3 = 10 / sqrt(d23 * 10);

                    float r3 = sin(t * 3 + 300);
                    float g3 = sin(t * 5 + 300);
                    float b3 = sin(t * 7 + 300);

                    float fr = l1 * r1 + l2 * r2 + l3 * r3;
                    float fg = l1 * g1 + l2 * g2 + l3 * g3;
                    float fb = l1 * b1 + l2 * b2 + l3 * b3;
                    float d = 1;

                    return fixed4(fr / d, fg / d, fb / d, 1);
                }
            }
            ENDCG
        }
    }
}
