/**
  ******************************************************************************
  * \file    stm32f0xx_it.c
  * \author  Александр Смирнов
  * \version 1.0.0
  * \date    20.06.2023
  * \brief   Шаблон файла с подрограммами обработчиками исключений и
  *          прерываний.
  ******************************************************************************
  */

#include "stm32f0xx_hal.h"

/******************************************************************************/
/*             Обрабочики исключений (exceptions) Cortex-M0                   */
/******************************************************************************/

/**
  * \brief  This function handles NMI exception.
  * \param  нет
  * \retval нет
  */
void NMI_Handler(void)
{
}

/**
  * \brief  This function handles Hard Fault exception.
  * \param  нет
  * \retval нет
  */
void HardFault_Handler(void)
{
  /* Go to infinite loop when Hard Fault exception occurs */
  while (1);
}


/**
  * \brief  This function handles SVCall exception.
  * \param  нет
  * \retval нет
  */
void SVC_Handler(void)
{
}


/**
  * \brief  This function handles PendSVC exception.
  * \param  нет
  * \retval нет
  */
void PendSV_Handler(void)
{
}

/**
  * \brief  This function handles SysTick Handler.
  * \param  нет
  * \retval нет
  */
void SysTick_Handler(void)
{
    HAL_IncTick();
}

/******************************************************************************/
/*                 STM32F0xx Peripherals Interrupt Handlers                   */
/*  Add here the Interrupt Handler for the used peripheral(s) (PPP), for the  */
/*  available peripheral interrupt handler's name please refer to the startup */
/*  file (startup_stm32f0xx.s).                                               */
/******************************************************************************/

/**
  * \brief  This function handles PPP interrupt request.
  * \param  нет
  * \retval нет
  */
/*void PPP_IRQHandler(void)
{
}*/
