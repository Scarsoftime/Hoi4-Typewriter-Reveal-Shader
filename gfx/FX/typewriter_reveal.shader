### Typewriter text reveal by Scars
# Recommended for monospaced fonts
# How to activate animation:
#	- Give the element (that was assigned the gfx) a _click_enabled trigger
#	- Alternate between having the trigger evaluate TRUE or FALSE (e.g. country flag that constantly flips) to trigger the animation

Includes = {
	"buttonstate.fxh"
	"sprite_animation.fxh"
}

PixelShader =
{
	Samplers =
	{
		MapTexture =
		{
			Index = 0
			MagFilter = "Point"
			MinFilter = "Point"
			MipFilter = "None"
			AddressU = "Wrap"
			AddressV = "Wrap"
		}
	}
}


VertexStruct VS_OUTPUT
{
	float4  vPosition : PDX_POSITION;
	float2  vTexCoord : TEXCOORD0;
};

VertexShader =
{
	MainCode VertexShader
	[[
		VS_OUTPUT main(const VS_INPUT v )
		{
			VS_OUTPUT Out;
			Out.vPosition = mul(WorldViewProjectionMatrix, float4(v.vPosition.xyz, 1));
			Out.vTexCoord = v.vTexCoord;
			return Out;
		}
	]]
}

PixelShader =
{
	MainCode PixelShader
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			// Put the frame information as XXYYY
			// X is the number of characters per line
			// Y is the number of lines

			// For example, 19 lines with 27 characters per line will be `frame = 19027`

			float charactersPerLine = mod(Offset.x,1000) + 1;
			float numberOfLines = floor(Offset.x/1000);
			float linesPerSecond = 0.4;

			float t = (Time - AnimationTime) * linesPerSecond;

			float currentLine = floor(t);
			float currentChar = floor(frac(t) * charactersPerLine);

			float cellX = floor(v.vTexCoord.x * charactersPerLine);
			float cellY = floor(v.vTexCoord.y * numberOfLines);

			if(cellY > currentLine)
				return tex2D(MapTexture, v.vTexCoord);

			if(cellY == currentLine)
			{
				if(cellX == currentChar)
					return float4(0.0, 0.0, 0.0, 1.0);   // cursor
				else if(cellX < currentChar)
					return float4(0.0, 0.0, 0.0, 0.0);   // already typed
				else
					return tex2D(MapTexture, v.vTexCoord);
			}

			return float4(0.0, 0.0, 0.0, 0.0);

		}
	]]
}

BlendState BlendState
{
	BlendEnable = yes
	SourceBlend = "src_alpha"
	DestBlend = "inv_src_alpha"
}

Effect Up
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShader"
}

Effect Down
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShader"
}

Effect Disable
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShader"
}

Effect Over
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShader"
}