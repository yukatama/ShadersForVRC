Shader "Yukatama/AudioLink/Experiments"
{
    Properties
    {
        [HideInInspector] _AudioLink ("AudioLink Texture", 2D) = "black" {}
        BaseRotX ("Base Rotation Speed X", Float) = 0.3
        BaseRotY ("Base Rotation Speed Y", Float) = 0.5
        BaseRotZ ("Base Rotation Speed Z", Float) = 0.7
        BassWeight ("Bass Weight", Float) = 1.0
        TrebleWeight ("Treble Weight", Float) = 1.0
    }
    SubShader
    {
        //Tags { "RenderType"="Opaque" }
        Tags {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }
        Blend One One
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "../../../Tools/AudioLink/Shaders/AudioLink.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 position : TEXCOORD;
            };

            uniform float BaseRotX;
            uniform float BaseRotY;
            uniform float BaseRotZ;
            uniform float BassWeight;
            uniform float TrebleWeight;

            v2f vert (appdata v)
            {
                v2f o;
                float3 rotation = (BaseRotX, BaseRotY, BaseRotZ) * _Time.y;
                if (AudioLinkIsAvailable()) {
                    rotation.x += AudioLinkData(ALPASS_AUDIOLOWMIDS).r;
                    rotation.y += AudioLinkData(ALPASS_AUDIOHIGHMIDS).r;
                }
                float cosX = cos(rotation.x);
                float sinX = sin(rotation.x);
                float cosY = cos(rotation.y);
                float sinY = sin(rotation.y);
                float cosZ = cos(rotation.z);
                float sinZ = sin(rotation.z);
                float4x4 rotationXYZ = float4x4(
                    float4(cosY * cosZ, cosY * sinZ, -sinY, 0),
                    float4(sinX * sinY * cosZ - cosX * sinZ, sinX * sinY * sinZ + cosX * cosZ, sinX * cosY, 0),
                    float4(cosX * sinY * cosZ + sinX * sinZ, cosX * sinY * sinZ - sinX * cosZ, cosX * cosY, 0),
                    float4(0, 0, 0, 1));
                o.vertex = mul(rotationXYZ, v.vertex);
                if (AudioLinkIsAvailable()) {
                    o.vertex = o.vertex * (1.0 + AudioLinkData(ALPASS_AUDIOTREBLE).r * TrebleWeight);
                    o.vertex.y -= AudioLinkData(ALPASS_AUDIOBASS).r * BassWeight;
                }
                o.vertex = UnityObjectToClipPos(o.vertex);
                o.position = v.vertex.xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float t = _Time.y;
                float3 pos = i.position / 0.003;
                pos += fixed3(0, -25, 0);
                float r = sin(t * 3 + pos.x);
                float g = sin(t * 7 + pos.y);
                float b = sin(t * 11 + pos.z);
                return fixed4(r, g, b, 1);
            }
            ENDCG
        }
    }
}
