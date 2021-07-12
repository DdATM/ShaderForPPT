Shader "PPT/07随机线条"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex("Texture",2D)="white"{}
        _Ratio("Ratio",Range(0,1))=0
        _Width("Width",float)=0.1
        _RandomBarNum ("RandonBarNum",int)=20
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
            float _Width;
            int _RandomBarNum;
            
            fixed4 mix(fixed4 col1,fixed4 col2,float ratio)
            {               
                return col1*(1-ratio)+col2*ratio;           
            }
            float random(int seed)
            {
                return frac(cos(seed) * 10.0);
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
                fixed4 col2=  tex2D(_SecondTex,i.uv);                              
             
                float alpha=1.0;    
                for (int j = 0; j < _RandomBarNum; j++)
                {   
                    float pos = random(j);
                    alpha=min(alpha, clamp(abs(i.uv.x / _Width - pos / _Width) + 1.0 + _Ratio * (-( 1.0 / _RandomBarNum * 3.0) / _Width - 1.0), 0.0, 1.0));
                }                            
                fixed4 col=mix(col2,col1,alpha) ;         
                return col;
            }
           
           
          
            ENDCG
        }
    }
}