Shader "PPT/15时钟"
{
  Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _SecondTex ("SecondTex", 2D) = "white" {}
        _Ratio("Ratio",Range(0,1))=0
        _Width("Width",Range(0.01,1))=0.01
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
            float _Width;
            
            fixed4 mix(fixed4 col1,fixed4 col2,float ratio)
            {               
                return col1*(1-ratio)+col2*ratio;           
            }
            float atan2(float a,float b)
            {
              if (a > 0 && b > 0)
              {
               return atan(b / a);
              }
               
              if (a < 0 && b > 0)
              {
                return atan(-a / b) + PI / 2.0;
              }
             
              if (a < 0 && b < 0)
              {
                return atan(b / a) + PI;
              }
               
              if (a > 0 && b < 0)
              {
                return atan(a / -b) + PI * 3.0 / 2.0;
              }                
              return 1;
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
              float4 texColor1 = tex2D(_MainTex, i.uv);
              float4 texColor2 = tex2D(_SecondTex, i.uv);
              float w = 0.5;
              float theta = atan2(i.uv.y-0.5,i.uv.x-0.5);
   
              float alpha = clamp(1 / _Width * theta + 1.0 + _Ratio * (-2.0 * PI / _Width - 1.0), 0.0, 1.0);
              return mix(texColor2, texColor1, alpha);
            }
            ENDCG
        }
    }   
}