/**
  ******************************************************************************
  * \file    main.c
  * \author  Александр Смирнов
  * \version 1.0.1
  * \date    12.08.2023
  * \brief   Шаблон программы на языке C и проекта связки инструментов vscode и gcc.
  *          Проект полностью настроен для учебного стенда и содержит
  *          простейшую программу управления одним светодиодом.
  *          В верхнем положении ключа SW1 светодиод D1 мигает,
  *          в нижнем светодиод D1 выключен.
  *          Программа работает в режиме 0 учебного стенда (S1 = 0, S2 = 0).
  ******************************************************************************
  */

/* Подключение заголовочного файле библиотеки HAL.
   Для включение всех модулей библиотеки необходимо
   раскомментировать нужный модуль в файл stm32f0xx_hal_conf.h и
   добавить исходный файл этого модуля в Makefile */
#include "stm32f0xx_hal.h"

/* Функция main - точка входа в программу */
int main(void)
{
    /* Инициализация библиотеки HAL */
    HAL_Init();

    /* Включение тактирования модулей */
    __HAL_RCC_GPIOA_CLK_ENABLE(); /* Включение тактирования порта A */
    __HAL_RCC_GPIOC_CLK_ENABLE(); /* Включение тактирования порта C */

    /* Настройка на ввод линии PA11 (SW1) с включение подтягивающего резистора */
    HAL_GPIO_Init(GPIOA, &(GPIO_InitTypeDef){
        .Pin = GPIO_PIN_11,
        .Mode = GPIO_MODE_INPUT,
        .Pull = GPIO_PULLUP,
        .Speed = GPIO_SPEED_FREQ_HIGH
    });

    /* Настройка на вывод линии PC0 (D1) */
    HAL_GPIO_Init(GPIOC, &(GPIO_InitTypeDef){
        .Pin = GPIO_PIN_0,
        .Mode = GPIO_MODE_OUTPUT_PP,
        .Pull = GPIO_NOPULL
    });

    /* Бесконечный цикл */
    while (1)
    {
        if (HAL_GPIO_ReadPin(GPIOA, GPIO_PIN_11))
        {
            HAL_GPIO_WritePin(GPIOC, GPIO_PIN_0, 0);
        }
        else
        {
            HAL_GPIO_TogglePin(GPIOC, GPIO_PIN_0);
            HAL_Delay(500);
        }
    }
}

#ifdef USE_FULL_ASSERT
#include <stdio.h>
/**
  * \brief  Вызывается когда произошла ошибка assert
  *         в библиотеке HAL. Assert включается в stm32f0xx_hal_conf.h
  * \param  file: указатель на имя исходного файла
  * \param  line: номер строки в исходном файле
  * \retval Нет
  */
void assert_failed(uint8_t *file, uint32_t line)
{
    printf("Wrong parameters value: file %s on line %lu", file, line);

    while (1);
}
#endif
