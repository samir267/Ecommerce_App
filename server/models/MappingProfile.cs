using AutoMapper;
using server.Dto;
using server.models.server.Models;

namespace back_wachify.Data_Layer
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<CartModel, CartDto>();
            CreateMap<CartDto, CartModel>();
            CreateMap<CartModel, CartResultDto>()
                .ForMember(dest => dest.Product, opt => opt.MapFrom(src => src.Product));
        }
    }
}