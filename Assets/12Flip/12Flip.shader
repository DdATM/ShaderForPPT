Shader "PPT/12翻转"
{
   
   Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex ("Texture", 2D) = "white" {}
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
            #define PI 3.1415926

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
            
            float2 transform(float2 uv,float theta,float zOffset)
            {
                float2 res=uv-0.5;
                res.x=res/cos(theta);
                res.y=res.y/(1.0-res.x*sin(theta));
                res.x=res.x/(1.0-res.x*sin(theta));
                res=res*(1.0+zOffset);
                res=res+0.5;
                if(res.x<0)
                {
                  res=-1;
                }
                if(res.y<0)
                {
                res=-1;
                }
                return res;
            }
         
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }


            fixed4 frag (v2f i) : SV_Target
            {             
              float zOffset=0.2-abs(0.4*_Ratio-0.2);
              float2 texUVAfterTransform=transform(i.uv,_Ratio*PI,zOffset);
              float4 resColor;
              float4 texColor1=tex2D(_MainTex,texUVAfterTransform);
              float4 texColor2=tex2D(_SecondTex,float2(1.0-texUVAfterTransform.x,texUVAfterTransform.y));
           
              
              if(texUVAfterTransform.x<0||texUVAfterTransform.y<0||texUVAfterTransform.x>1||texUVAfterTransform.y>1)
              {
                discard;
              }    
            // float e=step(_Ratio,0.5);
            // resColor=texColor1*e+texColor2*(1-e);
              if(_Ratio<=0.5)
               {
                 resColor=texColor1;
               }else
               {
                 resColor=texColor2;
               }
              return resColor;
             //return float4(texUVAfterTransform.x,texUVAfterTransform.y,0,0);
            }
            ENDCG
        }
    }
}