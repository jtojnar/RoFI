#include <driver/gpio.h>
#include <tcpip_adapter.h>

#include <esp_log.h>
#include <esp_wifi.h>

#include <vector>
#include <tuple>
#include <iostream>

#include "dock.hpp"
#include "roif.hpp"
#include "freeRTOS.hpp"
#include "test/test.hpp"

#include "examples/udpExample.hpp"
#include "examples/tcpExample.hpp"

extern "C" wifi_init_config_t getDefaultWifiCfg() ;

void setupStack() {
    tcpip_adapter_init();
    // WiFi is hard-wired into ESP-IDF and into the stack; not initializing it
    // causes crash.
    auto cfg = getDefaultWifiCfg();
    esp_wifi_init( &cfg );
    esp_wifi_start();
}

bool isMaster() {
    static int result = -1;
    if ( result == -1 ) {
        uint8_t macAddress[ 6 ];
        esp_efuse_mac_get_default( macAddress );

        result = macAddress[ 5 ] == 136;

        std::cout << "Mac Adress: ";
        const char* separator = "";
        for ( int x : macAddress ) {
            std::cout << separator << x;
            separator = ":";
        }
        std::cout << "\n";
    }
    return result;
}

extern "C" void app_main() {
    setupStack();
    isMaster();
    std::cout << "I am " << ( isMaster() ? "master" : "slave" ) << "\n";

    gpio_install_isr_service( ESP_INTR_FLAG_SHARED | ESP_INTR_FLAG_LOWMED | ESP_INTR_FLAG_IRAM );
    spi_bus_config_t spiBus = SpiBusConfig()
        .mosi( 5 )
        .miso( 18 )
        .sclk( 19 );
    auto r = spi_bus_initialize( HSPI_HOST, &spiBus, 1 );
    ESP_ERROR_CHECK( r );

    _rofi::RoIF roif( isMaster() ? "192.168.42.1" : "192.168.42.2", "255.255.255.0",
        "192.168.1.5", { GPIO_NUM_14 } );
    roif.setUp();
    std::cout << "roif initialized\n";

    if ( isMaster() )
        tcpEx::runMaster();
    else
        tcpEx::runSlave( "192.168.42.1" );

    while ( true ) vTaskDelay( 2000 / portTICK_PERIOD_MS );
}