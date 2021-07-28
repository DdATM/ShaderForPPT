Shader "PPT/16涟漪"
{
   Properties
    {
        _MainTex ("MainTex", 2D) = "white" {}
        _SecondTex ("SecondTex", 2D) = "white" {}
        _Ratio("Ratio",Range(0,1))=0   
        _ScreenX("ScreenX",float)=100
        _ScreenY("ScreenY",float)=100
        _Radius("Radius",Range(0.01,1))=0.01
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
            float _Ratio,_Radius;          
            float _ScreenX,_ScreenY;
          
            
            float2 transform(float2 texCoord, float2 waveCenter, float radiusOffset)
            {
                float2 res = texCoord;
                res = res - waveCenter;
                float radius = sqrt(pow(res.x, 2.0) + pow(res.y / _ScreenX * _ScreenY, 2.0));
                res = res + radiusOffset * float2(res.x, res.y / _ScreenX * _ScreenY) / _Radius;
                res = res + waveCenter;
                return res;
            }
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
              // 水波纹的周期
                float T = PI / 30.0;
                // 水波纹的波的个数
                float waveNum = 3.0;
                // 水波纹中心
                float2 waveCenter = float2(0.5, 0.5);
                float texR = sqrt(pow(i.uv.x - waveCenter.x, 2.0) + pow((i.uv.y - waveCenter.y) / _ScreenX * _ScreenY, 2.0));       
                float radiusOffset = 0.0; // 初始化折射的偏移量，没有用真实的折射公式来计算，仅仅是根据水波纹的梯度作了偏移
                float intensityOffset = 0.0; // 初始化亮度的调整量，同样根据水波纹的梯度来修改
                // 限定波的出现范围
                if (texR > _Ratio * (sqrt(2.0) + waveNum * T) - waveNum * T && texR < _Ratio * (sqrt(2.0) + waveNum * T))
                {
                    float sinFunction = sin(texR * 2.0 * PI / T - _Ratio * 2.0 * PI / T * ((sqrt(2.0) + waveNum * T)));
                    radiusOffset = 0.02 * sinFunction;
                    intensityOffset = 0.1 * sinFunction;
                }
                // 设置混合参数，为简单的线性函数，同Shape里面的圆形
                float alpha = clamp((_Ratio * (sqrt(2.0) + waveNum * T) - texR) / (1.0 / 2.0 * T), 0.0, 1.0);
            
                float2 texCoordAfterTransform = transform(i.uv, waveCenter, radiusOffset);
                float4 texColor1 = tex2D(_MainTex, texCoordAfterTransform);
                float4 texColor2 = tex2D(_SecondTex, texCoordAfterTransform);        
                float4 resColor = mix(texColor1, texColor2, alpha);
                resColor = resColor * (1.0 + intensityOffset);
               return resColor;
            }
            ENDCG
        }
    }    
}