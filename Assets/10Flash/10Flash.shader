Shader "PPT/10闪光"
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
                fixed4 resColor;
                float e;          
                e= step(_Ratio,0.5);                         
                resColor= (tex2D(_MainTex,i.uv)+float4(1,1,1,1)*_Ratio*2.0)*e+ ( tex2D(_SecondTex,i.uv) + float4(1,1,1,1)*(1.0-(_Ratio-0.5)*2.0) )*(1-e);
                return resColor;              
            }
           
            ENDCG
        }                  
    }
}