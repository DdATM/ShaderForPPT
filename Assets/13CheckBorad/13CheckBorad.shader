Shader "PPT/13棋盘"
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
  
            float2 transform(float2 uv,float theta,float2 axisPos,float2 gridNum)
            {
                float2 res=uv-axisPos;
                res.x=res/cos(theta);
                res.y=res.y/(1.0-res.x*2*sin(theta));
                res.x=res.x/(1.0-res.x*2*sin(theta));              
                res=res+axisPos;
                
                float halfGridWidth = 0.5/gridNum.x;
                float halfGridHeight = 0.5/gridNum.y;
                if(res.x<axisPos.x-halfGridWidth)
                {
                  res.x=-0.001;
                }
                if(res.x>axisPos.x+halfGridWidth)
                {
                  res.x=1.001;
                }
                 if(res.y<axisPos.y-halfGridHeight)
                {
                  res.y=-0.001;
                }
                if(res.y>axisPos.y+halfGridHeight)
                {
                  res.y=1.001;
                }
                
                return res;
            }
            float random(float2 st)
            {
               return frac(sin(dot(st.xy, float2(12.9898, 78.233))) * 43758.5453123);           
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
              float2 gridNum = float2(9.0,7.0);     
              float2 axisPos = floor(i.uv * gridNum) * (1.0 / gridNum) + 0.5 / gridNum;     
              float rotateTheta = clamp(axisPos.x * 2.0 - 4.0 * _Ratio + 1.0 + 2.0*(random(axisPos)-0.5) * _Ratio, 0.0, 1.0) * PI;               
              float2 texCoordAfterTransform = transform(i.uv, rotateTheta, axisPos, gridNum);    
              float4 texColor1 = tex2D(_MainTex, texCoordAfterTransform);  
              texCoordAfterTransform.x = floor(texCoordAfterTransform.x * gridNum.x + 1.0) / gridNum.x - texCoordAfterTransform.x + floor(texCoordAfterTransform.x * gridNum.x) / gridNum.x;
              float4 texColor2 = tex2D(_SecondTex, texCoordAfterTransform);     
              float4 resColor;
            
              if (rotateTheta <= 0.5 * PI)
              {
                float rotateThetaNor = rotateTheta  * 2.0 / PI;
                resColor = texColor1 * (1.0  - rotateThetaNor * 0.5) ;            
              } else if (rotateTheta > 0.5 * PI)
              {
                float rotateThetaNor = (rotateTheta -0.5 * PI) * 2.0 / PI;
                resColor = texColor2 * (0.5 + rotateThetaNor * 0.5);
              }
         
             if(texCoordAfterTransform.x<0||texCoordAfterTransform.y<0||texCoordAfterTransform.x>1||texCoordAfterTransform.y>1)
              {
               discard;
              }                
             return resColor;    
                
            }
            ENDCG
        }
    }   
}