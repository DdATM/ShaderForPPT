Shader "PPT/09覆盖"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex("Texture",2D)="white"{}
        _Ratio("Ratio",Range(0,1))=0
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SecondTex;
            float4 _SecondTex_ST;
            float _Ratio;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);             
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float r=1-_Ratio;
                fixed4 resColor;
                float e1,e2;
                float2 uv1,uv2;
                e1= step(r,i.uv.x);
                e2=step(r,i.uv.y);
                uv1=i.uv-float2(r,r);
                uv2=i.uv;
               resColor= tex2D(_SecondTex,uv1)*e1*e2+(tex2D(_MainTex, uv2)*(1-e2) + tex2D(_MainTex, uv2)*(1-e1)-tex2D(_MainTex, uv2)*(1-e1)*(1-e2) );
                return resColor;              
            }
            ENDCG
        }
    }
}