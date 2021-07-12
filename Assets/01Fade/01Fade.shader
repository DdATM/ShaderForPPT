Shader "PPT/01淡入淡出"
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
            
            fixed4 mix(fixed4 col1,fixed4 col2,float ratio)
            {
                return col1*(1-ratio)+col2*ratio;           
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
                
                fixed4 col1 = tex2D(_MainTex, i.uv);   
                fixed4 col2=tex2D(_SecondTex,i.uv);
                fixed4 col=mix(col1,col2,_Ratio) ;         
                return col;
            }
           
            ENDCG
        }
    }
}
