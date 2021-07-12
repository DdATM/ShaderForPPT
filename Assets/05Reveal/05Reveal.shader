Shader "PPT/05显示"
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
             
            float2 transform(float2 uv,float2 scaleCenter,float2 scaleRatio)
            {
                float2 res=uv;
                res=res-scaleCenter;
                res=res/scaleRatio;
                res=res+scaleCenter;
                return res;           
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
               float4 resColor;
               float w=1.0;
               if(_Ratio<=0.5)
               {
                   float ratioNor=_Ratio*2.0;
                   float2 scaleRatio=(1.0+0.1*ratioNor);
                   float4 texColor1=tex2D(_MainTex,transform(i.uv,float2(0.75,0.5),scaleRatio));
                   float alpha=clamp(-1.0/w*i.uv.x+(1.0+w)/w*(1.0-ratioNor),0.0,1.0);
                   resColor=mix(float4(1.0,1.0,1.0,1.0),texColor1,alpha);
               }
               else
               {
                   float ratioNor = (_Ratio - 0.5) * 2.0;
                   float2 scaleRatio = (1.0 + 0.1 * (1.0-ratioNor));
                   float4 texColor2 = tex2D(_SecondTex, transform(i.uv, float2(0.25, 0.5), scaleRatio));
                   float alpha = 1.0-clamp(-1.0 / w * i.uv.x + (1.0 + w) / w * ratioNor, 0.0, 1.0);
                   resColor = mix(texColor2,float4(1.0,1.0,1.0,1.0), alpha);
               }
                   return resColor;  
            }
            
            ENDCG
        }
    }
}