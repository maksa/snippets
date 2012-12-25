//
//  Polumentizator.m
//  Polumenta
//
//  Created by Milan Maksimovic on 12/25/12.
//  Copyright (c) 2012 maksa. All rights reserved.
//

#import "Polumentizator.h"
#include <stdlib.h>

@implementation Polumentizator
-(NSString*)polumentizuj {
	return [ self polumentizujSaOpcijom:@"" ];
}
-(NSString*)polumentizujSaOpcijom:(NSString*)opt {
	NSArray* slova = @[
	@[ @"Б", @"В", @"Г", @"Д", @"Ђ", @"Ж", @"З", @"Ј", @"К", @"Л", @"Љ", @"М", @"Н", @"Њ", @"П", @"Р",
	@"С", @"Т", @"Ћ", @"Ф", @"Х", @"Ц", @"Ч", @"Џ", @"Ш", @"Б", @"В", @"Г", @"Д", @"Ђ", @"Ж", @"З",
	@"Ј", @"К", @"Л", @"Љ", @"М", @"Н", @"Њ", @"П", @"Р", @"С", @"Т", @"Ћ", @"Ф", @"Х", @"Ц", @"Ч",
	@"Џ", @"Ш", @"Бл", @"Бр", @"Вл", @"Вр", @"Гл", @"Гр", @"Дл", @"Др", @"Жл", @"Зл", @"Зр",
	@"Кр", @"Кл", @"Мр", @"Мл", @"Пј", @"Пл", @"Пљ", @"Пњ", @"Пр", @"Св", @"Сл", @"См", @"Сп",
	@"Ст", @"Тл", @"Тр", @"Фл", @"Фљ", @"Фњ", @"Фр", @"Хл", @"Хр"],
	@[ @"а", @"е", @"и", @"о", @"у", @"р"],
	@[ @"б", @"в", @"г", @"д", @"ђ", @"ж", @"з", @"ј", @"к", @"л", @"љ", @"м", @"н", @"њ", @"п", @"р",
	@"с", @"т", @"ћ", @"ф", @"х", @"ц", @"ч", @"џ", @"ш" ]];
	
	int l1 = [ slova[0] count ];
	int r = arc4random_uniform( l1 - 1 );
	
	NSString* t1 = slova[0][r];
	
	NSString* a;
	if( [ t1 length ] == 1 )
		a = [ t1 substringFromIndex:([ t1 length ] - 1) ];
	else
	{
		a = [ t1 substringFromIndex:([ t1 length ] - 2) ];
	}
	
	NSString* charset = @"лрјљњЂЖЈЛЉНЊРЋЧЏШ";
	NSRange found = [ charset rangeOfString: a ];
	int dec;
	if ( found.location != NSNotFound )
		dec = 2;
	else
		dec = 1;
	
	NSString* t2 = slova[1][ arc4random_uniform([ slova[1] count ] - dec ) ];		NSString* t3 = slova[2][ arc4random_uniform([ slova[2] count ] - 1 ) ];
	
	NSString* t4;
	
	if ( [ opt isEqualToString:@"lolo" ] ) {
		t4 = [ NSString stringWithFormat:@"%@%@%@o", t3, t2, t3 ];
	} else if ( [ opt isEqualToString:@"fljizo" ])
	{
		NSString* t = @"";
		NSArray* p =  @[ @"б", @"в", @"г", @"д", @"ђ", @"ж", @"з", @"ј", @"к", @"л", @"љ", @"м", @"н", @"њ", @"п", @"р",
		@"с", @"т", @"ћ", @"ф", @"х", @"ц", @"ч", @"џ", @"ш", @"б", @"в", @"г", @"д", @"ђ", @"ж", @"з",
		@"ј", @"к", @"л", @"љ", @"м", @"н", @"њ", @"п", @"р", @"с", @"т", @"ћ", @"ф", @"х", @"ц", @"ч",
		@"џ", @"ш", @"бл", @"бр", @"вл", @"вр", @"гл", @"гр", @"дл", @"др", @"жл", @"зл", @"зр",
		@"кр", @"кл", @"мр", @"мл", @"пј", @"пл", @"пљ", @"пњ", @"пр", @"св", @"сл", @"см", @"сп",
		@"ст", @"тл", @"тр", @"фл", @"фљ", @"фњ", @"фр", @"хл", @"хр"];
		
		//NSString* t;
		NSRange fnd;
		do {
			int pcount = [ p count ];
			t = p[ arc4random_uniform( pcount -1 ) ];
			
			if( [ t length ] == 1 )
				a = [ t substringFromIndex:([ t length ] - 1) ];
			else
			{
				a = [ t substringFromIndex:([ t length ] - 2) ];
			}
			fnd = [ @"лрјљњђжнћчџш" rangeOfString: a ];
		} while ( [ t2 isEqualToString: @"р" ]  && fnd.location != NSNotFound );
		
		
		t4 =  [ NSString stringWithFormat:@"%@%@%@o", t, t2, t3 ];
		
	} else
	{
		t4 = @"";
	}
	
	NSString* final = [ NSString stringWithFormat:@"%@%@%@o%@ Полумента", t1, t2, t3, t4];
	
	return final;
	
}
@end
