Shader "Custom/HoloGram_Shader"
{
    Properties
    {
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
    }
    SubShader
    {
        Tags 
        { "RenderType"="Transparent" 
          "Queue" = "Transparent"
        }   
        //One Pass
        zwrite on 
        ColorMask 0
        CGPROGRAM
        #pragma surface surf nolight noambient nofowardadd nolightmap novertexlights noshadow
        struct Input
        {
            float4 color:COLOR; 
        };
        void surf (Input IN, inout SurfaceOutput o)
        {
        }
        float4 Lightingnolight (SurfaceOutput s, float3 lightDir, float atten){
            return float4(0,0,0,0);
            }
        ENDCG

         //Two Pass
         zwrite off
        CGPROGRAM
        #pragma surface surf Lambert alpha:fade
        sampler2D _MainTex;
        struct Input
        {
            float2 uv_MainTex;
            float3 viewDir;
            float3 worldPos;
        };
        void surf (Input IN, inout SurfaceOutput o)
        {
            float rim = saturate (dot(o.Normal, IN.viewDir));
            o.Emission = float3 (0,1,0);
            rim = pow(1-rim, 3) + pow(frac(IN.worldPos.g *2  - _Time.y * 0.2),30);
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = 0;
            o.Alpha = rim;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}
