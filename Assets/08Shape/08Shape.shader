Shader "PPT/08形状"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SecondTex("Texture",2D)="white"{}  
         _Ratio("Ratio",Range(0,1))=0
         _Width("Width",Range(0.01,1))=0.1
        _ScreenX("ScreenX",int)=1920
        _ScreenY("ScreenY",int)=1080
        _CenterX("CenterX",float)=0.5
        _CenterY("CenterY",float)=0.5
        [KeywordEnum(CIRCLE,DIAMOND,PLUS)]_Shape("Shape",int)=0
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
            #pragma multi_compile _SHAPE_CIRCLE _SHAPE_DIAMOND _SHAPE_PLUS    
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
            int _ScreenX;
            int _ScreenY;
            float _CenterX;
            float _CenterY;
            
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
              float4 texColor1=tex2D(_MainTex,i.uv);
              float4 texColor2=tex2D(_SecondTex,i.uv);
              float alpha=1.0;
              
              #if  _SHAPE_CIRCLE
                alpha=clamp((1.0 / _Width * sqrt(pow(i.uv.x - _CenterX, 2.0) + pow((i.uv.y -_CenterY) / _ScreenX * _ScreenY, 2.0))) + 1.0 + _Ratio * (-0.5 * sqrt(2.0) / _Width - 1.0), 0.0, 1.0);             
              #elif _SHAPE_DIAMOND
                alpha = clamp( abs(1.0 / _Width *(abs(i.uv.x - _CenterX) + abs(i.uv.y - _CenterY))) + 1.0 + _Ratio * (-0.5 * 2.0 / _Width - 1.0), 0.0, 1.0);
              #elif _SHAPE_PLUS
                alpha = min(clamp(abs(i.uv.x / _Width - 0.5 / _Width) + 1.0 + _Ratio * (-0.5 / _Width - 1.0), 0.0, 1.0), clamp(abs(i.uv.y / _Width - 0.5 / _Width) + 1.0 + _Ratio * (-0.5 / _Width - 1.0), 0.0, 1.0));
              #endif
              
              return mix(texColor1,texColor2,alpha);
            }
            
            ENDCG
        }
    }
}