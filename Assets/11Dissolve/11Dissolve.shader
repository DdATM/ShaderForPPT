Shader "PPT/11溶解"
{
   
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex("Texture",2D)="white"{}
        _GridX("GridX",int)=53
        _GridY("GridY",int)=30
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
            int _GridX;
            int _GridY;
            float _Ratio;

            float  random(float2 st)
            {           
               return frac(sin(dot(st,float2(12.9898,78.233)))*43758.54553123);
            }
            
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
                float4 texColor1=tex2D(_MainTex,i.uv);
                float4 texColor2=tex2D(_SecondTex,i.uv);
                float2 gridNum=float2(_GridX,_GridY);
                float randomNum=random(floor(i.uv*gridNum)/gridNum);
                float e=step(_Ratio,randomNum);
                return resColor=texColor1*e+texColor2*(1-e);            
            }
           
            ENDCG
        }                  
    }
}