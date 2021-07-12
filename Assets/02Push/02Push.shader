Shader "PPT/02推入"
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
            
            fixed4 Push(fixed4 pos,sampler2D main,sampler2D second,float ratio)
            {
               float r=1-ratio;
               fixed4 col;
               //step(r,pos.x)
               //if (pos.x>r)
             //      col=tex2D(main,i.uv-r);
             ///  else
              //     col=tex2D(second,i.uv-r+1);
             //  return col;          
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
             
               float r=1-_Ratio;
               fixed4 col;            
              if (i.uv.x>=r)
                 { i.uv.x=i.uv.x-r;
                  col=tex2D(_SecondTex,i.uv);
                  }
              else{
                  i.uv.x=i.uv.x-r+1;
                  col=tex2D(_MainTex,i.uv);
                  }
              return col;     
               
            }
           
            ENDCG
        }
    }
}
